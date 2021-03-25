
local Char = require('character')
local EventQueue = require('queue').new()
local Camera = require('Camera')

local scene = {}

local Debug = true

--[[ Event Holder ]]--
local eventHolder = {}

function eventHolder:subscribe(subject, callback)
  eventHolder[subject] = callback
end

function eventHolder:update(dt)
  local event = EventQueue:lpop()
  if event then
    print("event: " .. event[1])
    if self[event[1]] then
      self[event[1]](event)
    end
  end
end


--[[ Scene Load ]]--
--camera = Camera()
--camera.scale = 1
scene.Player = Char.new(100, 100, 'skins/testeB.png')

eventHolder:subscribe(
'PlayerMove',
function(event)
    scene.Player:moveListener(event)
end
)


--[[ Scene Update ]]--
function scene.update(dt)
  eventHolder:update(dt)
  scene.Player:update(dt)
  --camera:follow(scene.Player.x, scene.Player.y)
  --camera:update(dt)
end


--[[ Scene Draw ]]--
function scene.draw()
  --camera:attach()

  scene.Player:draw()

  --Debug logs on screen--
  if Debug then
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 40, 48)
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 40, 64)
  end
  
  --camera:detach()
  --camera:draw() -- Call this here if you're using camera:fade, camera:flash or debug drawing the deadzone
end


--[[ Love Keycallback ]]--
local keyCallbacks = {}

keyCallbacks['escape'] = love.event.quit

keyCallbacks['space']  = function() Debug = not Debug end
keyCallbacks['d']  = function() love.sm.switch('teste') end
--keyCallbacks['e']  = function() camera.scale = camera.scale + 1 end
--keyCallbacks['q']  = function() camera.scale = camera.scale - 1 end

keyCallbacks['left']   = function() EventQueue:rpush({'PlayerMove', 'l'}) end
keyCallbacks['right']  = function() EventQueue:rpush({'PlayerMove', 'r'}) end
keyCallbacks['up']     = function() EventQueue:rpush({'PlayerMove', 'b'}) end
keyCallbacks['down']   = function() EventQueue:rpush({'PlayerMove', 'f'}) end

local keyreleaseCallbacks = {}

do
  function stopPlayer() EventQueue:rpush({'PlayerMove', 'stop'}) end
  keyreleaseCallbacks['left']   = stopPlayer
  keyreleaseCallbacks['right']  = stopPlayer
  keyreleaseCallbacks['up']     = stopPlayer
  keyreleaseCallbacks['down']   = stopPlayer
end

function scene.keypressed(key)
  print('keypressed: ' .. key)
  pcall(keyCallbacks[key])
end

function scene.keyreleased(key)
  print('keyreleased: ' .. key)
  pcall(keyreleaseCallbacks[key])
end

return scene