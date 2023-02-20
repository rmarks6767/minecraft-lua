-- This is to allow importing of other files
-- adopted from: http://www.computercraft.info/forums2/index.php?/topic/27746-efficiently-working-with-multiple-source-files/
local require

do
  local requireCache = {}

  require = function(file)
    local absolute = shell.resolve(file)

    if requireCache[absolute] ~= nil then
      return requireCache[absolute]
    end

    local env = {
      require = require
    }

    setmetatable(env, { __index = _G, __newindex = _G })

    local chunk, err = loadfile(absolute, env)

    if chunk == nil then
      return error(err)
    end

    local result = chunk()
    requireCache[absolute] = result
    return result
  end
end

local Elevator = require("elevator.lua")

function Main()
  local elevator = Elevator:new()

  running = true

  while running do
    os.sleep(0)
    up = redstone.getInput('left')
    down = redstone.getInput('right')

    if (down or up) then 
      elevator:move(up)

      sleep(1)

      redstone.setOutput('back', false)
      redstone.setOutput('front', false)
    end
  end
end

Main()
