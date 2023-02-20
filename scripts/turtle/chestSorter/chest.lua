local Chest = {}

function Chest:new(id, x, y, z, facing)
  local c = setmetatable({}, { __index = Chest })

  -- This will be the way we access the chest
  c.id = id

  -- Location and direction the turtle placed it
  c.x = x
  c.y = y
  c.z = z
  c.facing = facing
  c.contents = {}

  return c
end

function Chest:AddItem(itemName, quantity)
  self.contents[itemName] = self.contents[itemName] + quantity
end

function Chest:GetContents()
  return self.contents
end

function Chest:Sort()
-- Also implemented later
end

function Chest:SaveContents()
-- This will be implemented later
end