require 'map-functions'
require 'character'
anim8 = require 'anim8'

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  elseif k == 'space' then
    --loadMap('maps/core-dump.lua')
    print(TileW)
  end
end
 
function love.update( dt )

  local vel = 3.6
  if love.keyboard.isDown('lshift') then
    vel = 7.2
  end
  if love.keyboard.isDown('w') then
    y = y - vel
    player:setState("B")
  end
  if love.keyboard.isDown('a') then
    x = x - vel
    player:setState("L")
  end
  if love.keyboard.isDown('s') then
    y = y + vel
    player:setState("F")
  end
  if love.keyboard.isDown('d') then
    x = x + vel
    player:setState("R")
  end
  player:Move(x, y)
  player.animation[player.state]:update(dt)
end

function love.load()
  local TileTable, tileW, tileH = loadMap('maps/chez-peter.lua')
  player = character('skins/saitama.lua')
  x, y = 32, 32
end

function love.draw()
  drawMap()
  player:draw()
end
