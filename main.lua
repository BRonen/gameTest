anim8 = require('anim8')
require('map')
require('character')

local debug = false

function love.load()

  love.physics.setMeter(32)

  local TileTable, tileW, tileH, f, Blocks, World = loadMap('maps/chez-peter.lua', World)

  player = character('skins/saitama.lua')
  player.b = love.physics.newBody(World, 400,300, "dynamic")
  player.s = love.physics.newRectangleShape(25,25)
  player.f = love.physics.newFixture(player.b, player.s)
  player.f:setUserData("Player")
  player.f:setRestitution(0.2)
  

end

function love.draw()
  drawMap()
  player:draw()
  if debug then
    for _, block in ipairs(blocks) do
      love.graphics.polygon("fill", block.b:getWorldPoints(block.s:getPoints()))
    end
    love.graphics.polygon("fill", player.b:getWorldPoints(player.s:getPoints()))
  end
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    player.b:applyForce(3200, 0)
    player.b:setLinearVelocity(0, 0)
    player:setState("R")
  end
  if love.keyboard.isDown("left") then
    player.b:applyForce(-3200, 0)
    player:setState("L")
  end
  if love.keyboard.isDown("up") then
    player.b:applyForce(0, -3200)
    player:setState("B")
  end
  if love.keyboard.isDown("down") then
    player.b:applyForce(0, 3200)
    player:setState("F")
  end
  player.animation[player.state]:update(dt)
  World:update(dt)
  player.b:setLinearVelocity(0, 0)
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then debug = not debug end
end
