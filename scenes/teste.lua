
local scene = {}

local Array = {}
for i=1,50 do
    Array[i] = math.random(1, 400)
end

function scene.keypressed(key)
    if key == "escape" then love.sm.switch('game') end
end

function scene.draw()
  for i=1,#Array do
    love.graphics.rectangle( "fill", i*7, 32, 6, Array[i] )
  end
end

local Index = 0
function scene.update(dt)
  Index = Index + 1
  if Index >= #Array  then
    Index = 1
  end
  if Array[Index] > Array[Index + 1] then
    local aux = Array[Index]
    Array[Index] = Array[Index + 1]
    Array[Index + 1] = aux
  end
end

return scene