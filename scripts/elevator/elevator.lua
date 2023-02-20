local Elevator = {}

function Elevator:new()
  -- Set the floor that the elevator is on
  local s = setmetatable({}, { __index = Elevator }) 
  s.floor = 1
  return s
end

function Elevator:move(up)
  if up then
    if self.floor ~= 3 then 
      redstone.setOutput('top', false)

      sleep(1)

      if self.floor == 2 then 
        redstone.setOutput('front', true)
      else
        redstone.setOutput('back', true)
      end

      self.floor = self.floor + 1
    end
  else 
    if self.floor ~= 1 then
      redstone.setOutput('top', true)

      sleep(1)

      if self.floor == 3 then 
        redstone.setOutput('front', true)
      else
        redstone.setOutput('back', true)
      end      
    
      self.floor = self.floor - 1
    end
  end
end

return Elevator