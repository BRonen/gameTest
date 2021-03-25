
local Char = require('character')
local EventQueue = require('queue').new()
local Camera = require('Camera')

local Debug = true
local Player

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


--[[ Love Load ]]--
function love.load(args)
  camera = Camera()
  camera.scale = 1
  Player = Char.new(100, 100, 'skins/testeB.png')

  eventHolder:subscribe(
    'PlayerMove',
    function(event)
      Player:moveListener(event)
    end
  )

  TileW, TileH = 32,32
  
  Tileset = love.graphics.newImage('tiles/countryside.png')
  
  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
  
  local quadInfo = { 
    {  0,  0 }, -- 1 = grass 
    { 32,  0 }, -- 2 = box
    {  0, 32 }, -- 3 = flowers
    { 32, 32 }, -- 4 = boxTop
  }

  Quads = {}
  for i,info in ipairs(quadInfo) do
    -- info[1] = x, info[2] = y
    Quads[i] = love.graphics.newQuad(info[1], info[2], TileW, TileH, tilesetW, tilesetH)
  end
  
  TileTable = {
  
     { 4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4 },
     { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,4 },
     { 4,1,3,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,4 },
     { 4,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,4 },
     { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
     { 4,1,1,4,1,1,1,1,1,2,2,1,1,4,1,1,1,4,1,4,2,2,1,1,4 },
     { 4,1,1,4,1,1,1,1,4,3,3,4,1,2,1,1,1,2,1,4,1,1,1,1,4 },
     { 4,1,1,4,1,1,1,1,4,3,3,4,1,1,4,1,4,1,1,4,2,2,1,1,4 },
     { 4,1,1,4,1,1,1,1,4,3,3,4,1,1,2,1,2,1,1,4,1,1,1,1,4 },           
     { 4,1,1,4,1,1,1,1,2,3,3,2,1,1,1,4,1,1,1,4,1,1,1,1,4 },
     { 4,1,1,2,2,2,2,1,1,2,2,1,1,1,1,2,1,3,1,2,2,2,1,1,4 },
     { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
     { 4,1,1,1,1,1,1,1,1,3,1,1,1,1,3,3,3,1,1,1,1,1,1,1,4 },
     { 4,1,1,1,1,1,1,1,3,3,1,1,3,1,3,3,3,1,1,1,1,1,1,1,4 },
     { 4,1,1,3,1,1,1,1,3,3,1,3,3,1,1,3,1,1,1,1,1,1,1,1,4 },
     { 4,1,1,1,1,1,1,1,1,3,1,3,3,1,3,3,1,1,1,1,1,1,3,1,4 },
     { 4,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,4 },
     { 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2 }
  }
end


--[[ Love Update ]]--
function love.update(dt)
  eventHolder:update(dt)
  Player:update(dt)
  camera:follow(Player.x, Player.y)
  camera:update(dt)
end


--[[ Love Draw ]]--
function love.draw()
  camera:attach()

  for rowIndex,row in ipairs(TileTable) do
    for columnIndex,number in ipairs(row) do
      local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
      love.graphics.draw(Tileset, Quads[number], x, y)
    end
  end

  Player:draw()

  --Debug logs on screen--
  if Debug then
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 40, 48)
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 40, 64)
  end
  
  camera:detach()
  camera:draw() -- Call this here if you're using camera:fade, camera:flash or debug drawing the deadzone
end


--[[ Love Keycallback ]]--
local keyCallbacks = {}

keyCallbacks['escape'] = love.event.quit

keyCallbacks['space']  = function() Debug = not Debug end
keyCallbacks['e']  = function() camera.scale = camera.scale + 1 end
keyCallbacks['q']  = function() camera.scale = camera.scale - 1 end

keyCallbacks['left']   = function() EventQueue:rpush({'PlayerMove', 'l'}) end
keyCallbacks['right']  = function() EventQueue:rpush({'PlayerMove', 'r'}) end
keyCallbacks['up']     = function() EventQueue:rpush({'PlayerMove', 'b'}) end
keyCallbacks['down']   = function() EventQueue:rpush({'PlayerMove', 'f'}) end

local keyreleaseCallbacks = {}
keyreleaseCallbacks['left']   = function() EventQueue:rpush({'PlayerMove', 'stop'}) end
keyreleaseCallbacks['right']  = function() EventQueue:rpush({'PlayerMove', 'stop'}) end
keyreleaseCallbacks['up']     = function() EventQueue:rpush({'PlayerMove', 'stop'}) end
keyreleaseCallbacks['down']   = function() EventQueue:rpush({'PlayerMove', 'stop'}) end

function love.keypressed(key)
  print('keypressed: ' .. key)
  pcall(keyCallbacks[key])
end

function love.keyreleased(key)
  print('keyreleased: ' .. key)
  pcall(keyreleaseCallbacks[key])
end