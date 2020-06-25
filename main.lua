
local Camera = require 'Camera'
local mapper = require 'map'
local joysticks = require 'joystick'
require 'character'

Statics = {}
colisoes = {}

function createStatic(label,x,y,w,h)
  local static = {}
  static.body = love.physics.newBody(World, x,y, "static")
  static.shape = love.physics.newRectangleShape(w,h)
  static.fixture = love.physics.newFixture(static.body, static.shape)
  static.fixture:setUserData(label)
  
  return static
end

function setcolisoes(target, owner, effect)
  colisoes[owner][target] = effect
end

function setKeyCallback(...)
  local callbacks = {}
  callbacks["d"] = function() Debug = not Debug end
  callbacks["space"] = function()  end
  callbacks["escape"] = function() love.event.push('quit') end
  callbacks["e"] = function() Cam.scale = Cam.scale + 1 end
  callbacks["q"] = function() Cam.scale = Cam.scale - 1 end
  return ... or callbacks
end

function love.load(args)
  Joystick = joysticks:init()

  love.graphics.setDefaultFilter('nearest', 'nearest');

  love.window.setTitle('Test')

  love.audio.newSource('ZeldaTheme.mp3', 'stream'):play()

  Debug = false

  love.physics.setMeter(64)

  mapper:new('/maps/chez-peter.lua')

  World:setCallbacks(beginContact)

  player = character('/skins/testeB.png', "Player")
  player:init(400,300)
  player.body:setMass(5)
  
  npc = character('/skins/saitama.png', "NPC")
  npc:init(200,300)
  npc.body:setMass(5)

  keyCallback = setKeyCallback()

  Cam = Camera()
  Cam:setFollowStyle('LOCKON')
  Cam:setFollowLerp(2)
  Cam:setFollowLead(0.5)
  Cam.scale = 1

end

function love.draw()
  Cam:attach()

  mapper:draw()
  player:draw()
  npc:draw()

  if Debug then
    love.graphics.circle("line", player.body:getX(), player.body:getY(), player.shape:getRadius())--player
    love.graphics.circle("line", player.activater.body:getX(), player.activater.body:getY(), player.activater.shape:getRadius())--player's collider
    
    love.graphics.circle("line", npc.body:getX(), npc.body:getY(), npc.shape:getRadius())
    love.graphics.circle("line", npc.activater.body:getX(), npc.activater.body:getY(), npc.activater.shape:getRadius())
    
    for _, obj in ipairs(Statics) do
      love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints())) --Static blocks
    end
    love.graphics.print('FPS: ' .. love.timer.getFPS(), Cam:toWorldCoords(32, 48))
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', Cam:toWorldCoords(32, 64))
  end
  Cam:detach()
  Cam:draw()
end

function love.gamepadpressed()
  return
end

function love.update(dt)
  if love.keyboard.isDown("space") then
    aaa = true
  else
    aaa = false
  end
  
  if love.keyboard.isDown("right") then
    player.move:right(dt)
  end
  if love.keyboard.isDown("left") then
    player.move:left(dt)
  end
  if love.keyboard.isDown("up") then
    player.move:up(dt)
  end
  if love.keyboard.isDown("down") then
    player.move:down(dt)
  end
  
  if Joystick:isGamepadDown('dpright') then
    npc.move:right(dt)
  end
  if Joystick:isGamepadDown('dpleft') then
    npc.move:left(dt)
  end
  if Joystick:isGamepadDown('dpup') then
    npc.move:up(dt)
  end
  if Joystick:isGamepadDown('dpdown') then
    npc.move:down(dt)
  end
  Cam:update(dt)
  World:update(dt)
  player:update(dt)
  npc:update(dt)
  Cam:follow(player.b:getPosition())
end

function love.keypressed(key)
  if keyCallback[key] then keyCallback[key]() end
  print(key)
end

function beginContact(a, b, coll)
  if aaa then
    if colisoes[b:getUserData()] and colisoes[b:getUserData()][a:getUserData()] then
      colisoes[b:getUserData()][a:getUserData()]()
    end
  end
end
