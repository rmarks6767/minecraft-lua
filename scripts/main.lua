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

local TurtlePlus = require("turtlePlus.lua")
local MineChunk = require("mineChunk.lua")

function Main()
  local turtleP = TurtlePlus:new()
  local program = arg[1]

  if (program == 'minechunk') then
    MineChunk(turtleP)
  end
end

Main()
