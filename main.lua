require 'map-functions'

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('quit')
  elseif k == 'space' then
    loadMap('maps/chez-peter.lua')
  end
end
 
function love.update( dt )
print(dt)
end

function love.load()
  loadMap('maps/core-dump.lua')
end

function love.draw()
  drawMap()
  --love.graphics.polygon('fill', {50, 0, 0, 100, 50, 150, 100, 100})
end
