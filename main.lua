anim8 = require('anim8')
Camera = require('Camera')
map = require('map')
require('character')

local debug = 1

function love.load(args)
  canvas = love.graphics.newCanvas( 100, 100, {} )

  for k, v in pairs(args) do
    print(k, v)
  end

  love.physics.setMeter(64)

  World = love.physics.newWorld()

  map.load('maps/chez-peter.lua')

  player = character('skins/saitama.lua')
  player:reset(400,300)

  camera = Camera()
  camera:setFollowStyle('LOCKON')
  camera:setFollowLerp(0.2)
  camera:setFollowLead(1)
  camera.scale = 1

end

function love.draw()
  camera:attach()
  map.draw()
  player:draw()
  if debug then
    for _, block in ipairs(blocks) do
      love.graphics.polygon("fill", block.b:getWorldPoints(block.s:getPoints()))
    end
    love.graphics.polygon("fill", player.b:getWorldPoints(player.s:getPoints()))
        local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        love.graphics.print(joystick:getName(), 10, i * 20)
    end
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 32, 48)
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 32, 64)
  end
  camera:detach()
  camera:draw()
end

function love.update(dt)
  player:test({
    open = function() loadnewmap('maps/chez-peter.lua') end,
    x = 400, y = 400
  })
  if love.keyboard.isDown("right") then
    player:resume()
    player.b:applyForce(300, 0)
    player:setState("R")
  end
  if love.keyboard.isDown("left") then
    player:resume()
    player.b:applyForce(-300, 0)
    player:setState("L")
  end
  if love.keyboard.isDown("up") then
    player:resume()
    player.b:applyForce(0, -300)
    player:setState("B")
  end
  if love.keyboard.isDown("down") then
    player:resume()
    player.b:applyForce(0, 300)
    player:setState("F")
  end
  if not (
    love.keyboard.isDown("down") or
    love.keyboard.isDown("up") or
    love.keyboard.isDown("left") or
    love.keyboard.isDown("right")
  ) then
    player:stop()
  end

  player.animation[player.state]:update(dt)
  World:update(dt)
  player.b:setLinearVelocity(0, 0)
  camera:update(dt)
  camera:follow(player.b:getPosition())
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then debug = not debug end
  if key == 'e' then camera.scale = camera.scale + 1 end
  if key == 'q' then camera.scale = camera.scale - 1 end
  if key == 'r' then
    loadnewmap('maps/core-dump.lua')
  end
  print(key)
end

function loadnewmap(mapa)
    map.load(mapa)
    player:reset(400,300)
end
