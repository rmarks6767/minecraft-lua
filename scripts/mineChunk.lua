function MineChunk(turtlePlus)
  local width = tonumber(arg[2])
  local height = tonumber(arg[3])
  local depth = tonumber(arg[4])

  local turn = 'right'
  turtlePlus:Move('forward')

  for i = 1, height do
    for j = 1, width do
      for k = 1, depth do
        print(depth)
        print(turn)
        print(k)
        if (depth == k) then
        else
          turtlePlus:Move('forward')
        end
      end
      if (j ~= width) then
        turtlePlus:Turn(turn)
        turtlePlus:Move('forward')
        turtlePlus:Turn(turn)

        if (turn == 'right') then
          turn = 'left'
        elseif (turn == 'left') then
          turn = 'right'
        end
      end
    end
    if ( i ~= height) then 
      turtlePlus:Move('up')
      turtlePlus:TurnAround()
    end
  end

  turtlePlus:ReturnHome()
end

return MineChunk