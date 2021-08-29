Input = require('libs.Input')()
Event = require('libs.Event')()
Timer = require('libs.Timer')()

local Mapper = require('libs.Mapper')()

DEBUG = false
local scale = 2

local World
local Player

function love.load(args)
  love.physics.setMeter(32)
  World = love.physics.newWorld(0, 0)

  DEBUG = (args[1] == '--debug') or (args[1] == '-D')
  
  love.graphics.setDefaultFilter('nearest', 'nearest')
  local w, h = love.graphics.getDimensions()

  if DEBUG then
    print('\n==========')
    print('PROCESSOR NUMBER: ', love.system.getProcessorCount())
    print('RESOLUTION:       ', w, h)
    print('POWER INFO:       ', love.system.getPowerInfo())
    print('OS INFO:          ', love.system.getOS())
    print('LUA VERSION:      ', _VERSION)
    
    local major, minor, revision, codename = love.getVersion()
    local loveVersion = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    print('LOVE VERSION:     ', loveVersion)
    print('==========\n')
  end

  Player = Mapper:load(World, 'teste.lua')
  Event:subscribe('movePlayer', function(event)
    Player:setDirection(event[2])
  end)
  Event:subscribe('rotatePlayer', function(event)
    Player:rotate(event[2])
  end)
  Event:subscribe('shotPlayer', function(event)
    Player:shot(World)
  end)

  Input:bind('w',    'up')
  Input:bind('s',  'down')
  Input:bind('d', 'right')
  Input:bind('a',  'left')

  Input:bind(   'dpup',    'up')
  Input:bind( 'dpdown',  'down')
  Input:bind( 'dpleft',  'left')
  Input:bind('dpright', 'right')
  
  Input:bind('l1', 'rotate-')
  Input:bind('r1', 'rotate+')

  Input:bind('q', 'rotate-')
  Input:bind('e', 'rotate+')

  Input:bind( 'fleft', 'shotPlayer')
  Input:bind('mouse1', 'shotPlayer')

  Input:bind('h', 'nextMap')

  Input:bind('tab', function()
    DEBUG = not DEBUG
    if DEBUG then
      scale = 1
    else
      scale = 1.3
    end
  end)
  
  Input:bind('esc', function() love.event.push("quit") end)
end

function love.update(dt)
  --something like a xor with oposite directions
  local dy = Input:down('up')    ~= Input:down('down')
  local dx = Input:down('right') ~= Input:down('left')
  if dy and dx then
    if Input:down('up')    then 
      if Input:down('right') then Event:emit({'movePlayer', 'ne'}) end
      if Input:down('left')  then Event:emit({'movePlayer', 'nw'}) end
    end
    if Input:down('down')  then 
      if Input:down('right') then Event:emit({'movePlayer', 'se'}) end
      if Input:down('left')  then Event:emit({'movePlayer', 'sw'}) end
    end
  elseif dy then
    if Input:down('up')    then Event:emit({'movePlayer', 'n'}) end
    if Input:down('down')  then Event:emit({'movePlayer', 's'}) end
  elseif dx then
    if Input:down('right') then Event:emit({'movePlayer', 'e'}) end
    if Input:down('left')  then Event:emit({'movePlayer', 'w'}) end
  end
  if not Input:down('up') and
     not Input:down('down') and
     not Input:down('left') and
     not Input:down('right') then
      Event:emit({'movePlayer', ''})
  end
  if Input:pressed('nextMap') then Mapper:load(World, 'test.lua') end
  if Input:released('nextMap') then Mapper:load(World, 'teste.lua') end

  if Input:down('rotate-') then Event:emit({'rotatePlayer', -200*dt}) end
  if Input:down('rotate+') then Event:emit({'rotatePlayer',  200*dt}) end

  if Input:pressed('shotPlayer') then Event:emit({'shotPlayer'}) end

  Input:update(dt)
  Event:update(dt)
  Timer:update(dt)

  Player:update(dt)
  
  World:update(dt)

  Mapper:update(dt)
end

function love.draw()
  love.graphics.push()

  local x, y = Player.b:getPosition()

	local tx = math.floor(x - love.graphics.getWidth()  / 2 )
	local ty = math.floor(y - love.graphics.getHeight() / 2 )

  love.graphics.translate((Player.offset.x), (Player.offset.y))

	love.graphics.rotate(-(Player.angle))
  love.graphics.scale(scale)
  
	love.graphics.translate(-tx, -ty)

  Mapper:draw(-(Player.offset.x), -(Player.offset.y))

  Player:drawShots(scale)

  love.graphics.pop()

  love.graphics.scale(scale)

  Player:draw(scale)

  if DEBUG then
    love.graphics.print('FPS: ' .. love.timer.getFPS(),
      32, 30
    )
    love.graphics.print(
      'Memory: ' .. math.floor(collectgarbage 'count') .. 'kb',
      150, 30
    )
  end
end

function love.resize(w, h)
  Player:setOffset(w/2, h/2)
end

function love.keypressed(key)
  Input:keypressed(key)
end

function love.keyreleased(key)
  Input:keyreleased(key)
end

function love.mousepressed(x, y, button)
  Input:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  Input:mousereleased(x, y, button)
end

function love.gamepadpressed(joystick, button)
  Input:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
  Input:gamepadreleased(joystick, button)
end