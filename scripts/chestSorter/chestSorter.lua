local Chest = {}

function Chest:new(id, directions, items)
  local c = setmetatable({}, { __index = Chest })

  -- This will be the way we access the chest
  c.id = id

  -- Location and direction the turtle placed it
  c.directions = directions
  c.contents = {}
  c.items = items
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

function ActionSatisfied(action, turtlePlus)
  if (action == 'coal') then
    local index = turtlePlus:FindItemIndex('minecraft:coal')

    if (index == 0) then
      turtlePlus:SuckAllFromChest()
      turtlePlus:KeepAlive()
      return false
    end

    return true
  end
  if (action == 'chests') then
    local index = turtlePlus:FindItemIndex('minecraft:chest')

    if (index == 0) then
      turtlePlus:SuckAllFromChest()
      turtlePlus:KeepAlive()
      return false
    end

    return true
  end
end

function WaitUntil(action, turtlePlus) 
  print(action .. ' needed to continue')
  repeat until ActionSatisfied(action, turtlePlus)
end

function HasStartItems(turtlePlus)
  -- WaitUntil('coal', turtlePlus)
  -- WaitUntil('chests', turtlePlus)
end

function FillInventoryOrEmptyChest(turtlePlus)
  repeat until turtlePlus:InventoryFull() or turtlePlus:SuckAllFromChest()
end

function ContainsItem(array, item)
  for i = 1, #array do
    if (array[i] == item) then
      return true
    end
  end

  return false
end

function FindChestForItem(chests, item)
  for k, _ in pairs(chests) do
    if (ContainsItem(chests[k].items, item)) then
      return chests[k], k
    end
  end

  return nil, nil
end

function ProcessItems(chests)
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)

    if (item ~= nil) then
      local chest, k = FindChestForItem(chests, item.name)

      if (chest ~= nil) then
        chest.directions()
        turtle.select(i)
        turtle.drop()
        table.insert(chests[k].contents, item)
      end
    end
  end
end

function ChestSorter(turtlePlus)
  local chests = {
    stoneChest = Chest:new('1', function() turtlePlus:GoTo(2, 0, 0, 'east') end, MincraftItemData.stone),
    oreChest = Chest:new('2', function() turtlePlus:GoTo(2, 0, 3, 'east') end, MincraftItemData.ore),
    woodChest = Chest:new('3', function() turtlePlus:GoTo(2, 0, 6, 'east') end, MincraftItemData.wood),
  }

  while true do
    FillInventoryOrEmptyChest(turtlePlus)
    if (turtlePlus:InventoryEmpty()) then break end
    ProcessItems(chests)
    turtlePlus:GoTo(0, 0, 0, 'north')
  end
end

return ChestSorter