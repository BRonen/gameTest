require 'map-functions'
require 'character'

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('quit')
  elseif k == 'space' then
    --loadMap('maps/core-dump.lua')
  elseif k == 'w' then
    y = y - 32
  elseif k == 'a' then
    x = x - 32
  elseif k == 's' then
    y = y + 32
  elseif k == 'd' then
    x = x + 32
  end
end
 
function love.update( dt )
  player:Move(x, y)
end

function love.load()
  loadMap('maps/chez-peter.lua')

  player = character('skins/saitama.lua')
  x, y = 32, 32
end

function love.draw()
  drawMap()
  player:draw()
end
