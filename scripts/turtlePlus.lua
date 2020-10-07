local TurtlePlus = {}
-- Right goes up, left goes down the array
local directionsIndex = { north=1, east=2, south=3, west=4 }
local directions = { 'north', 'east', 'south', 'west' }

function TurtlePlus:new()
  local s = setmetatable({}, { __index = TurtlePlus })

  -- Coord system
  s.x = 0
  s.y = 0
  s.z = 0
  s.facing = 'north'

  s.movementHistoryFuel = 0
  s.movementHistory = {}
  return s
end

function TurtlePlus:Refuel()
  local index = self:FindItemIndex('minecraft:coal')

  if (index ~= 0) then
    turtle.select(index)
    if (turtle.refuel(1) == true) then
      return true
    end
  end
  return false
end

function TurtlePlus:FindItemIndex(item)
  for i = 1, 16 do
    local data = turtle.getItemDetail(i)

    if (data.name == item) then
      return i
    end
  end
  return 0
end

function TurtlePlus:Turn(direction)
  local facing = self.facing

  if (direction == 'left') then
    turtle.turnLeft()
    table.insert(self.movementHistory, 'left')
    self.facing = directions[((directionsIndex[facing] - 2) % 4) + 1]
  end
  if (direction == 'right') then
    turtle.turnRight()
    table.insert(self.movementHistory, 'right')
    self.facing = directions[(directionsIndex[facing] % 4) + 1]
  end
end

function TurtlePlus:MoveFacing(direction)
  if (self.facing == 'north') then
    if (direction == 'forward') then
      self.z = self.z - 1
    else
      self.z = self.z + 1
    end
  end
  if (self.facing == 'east') then
    if (direction == 'forward') then
      self.x = self.x + 1
    else
      self.x = self.x - 1
    end
  end
  if (self.facing == 'south') then
    if (direction == 'forward') then
      self.z = self.z + 1
    else
      self.z = self.z - 1
    end
  end
  if (self.facing == 'west') then
    if (direction == 'forward') then
      self.x = self.x - 1
    else
      self.x = self.x + 1
    end
  end
end

function TurtlePlus:TurnAround()
  self:Turn('left')
  self:Turn('left')
end

function TurtlePlus:ReturnHome()
  local history = { table.unpack(self.movementHistory) }

  for i = #history, 1, -1 do
    local move = history[i]

    if (move == 'left') then
      self:Turn('right')
    elseif (move == 'right') then
      self:Turn('left')
    elseif (move == 'forward') then
      self:Move('back')
    elseif (move == 'up') then
      self:Move('down')
    elseif (move == 'down') then
      self:Move('up')
    end
  end

  self.movementHistory = {}
end

function TurtlePlus:Move(direction)
  --Before movement, check fuel level
  local fuelLevel = turtle.getFuelLevel()

  if (fuelLevel <= 60) then
    self:Refuel()
  end

  if (direction == 'down') then
    if (turtle.detectDown()) then
      turtle.digDown()
    end
    turtle.down()
    table.insert(self.movementHistory, 'down')
    self.movementHistoryFuel = self.movementHistoryFuel + 1
    self.y = self.y - 1
  elseif (direction == 'up') then
    if (turtle.detectUp()) then
      turtle.digUp()
    end
    turtle.up()
    table.insert(self.movementHistory, 'up')
    self.y = self.y + 1
  elseif (direction == 'forward') then
    if (turtle.detect()) then
      turtle.dig()
    end
    turtle.forward()
    table.insert(self.movementHistory, 'forward')
    self:MoveFacing('forward')
  elseif (direction == 'back') then
    -- Means we can't go back (blocked by a block)
    if(turtle.back() == false) then
      self:TurnAround()
      turtle.dig()
      self:TurnAround()
      turtle.back()
    end
    table.insert(self.movementHistory, 'back')
    self:MoveFacing('back')
  end
end

return TurtlePlus