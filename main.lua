local Char = require('libs.Char')

local World = love.physics.newWorld(0, 0)

local Mapper = require('libs.Mapper')

local Line = require('objects.shapes.Line')
local Walls = {}

local DEBUG = true

local p
local mapper

function love.load(args)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  local w, h = love.graphics.getDimensions()

  if DEBUG then
    print('\n==========')
    print('PROCESSOR NUMBER: ', love.system.getProcessorCount())
    print('RESOLUTION:       ', w, h)
    print('POWER INFO:       ', love.system.getPowerInfo())
    print('OS INFO:          ', love.system.getOS())
    print('==========\n')
  end

  mapper = Mapper:new(World)
  
  p = Char:new(World, 160, 360)
end

function love.update(dt)
  World:update(dt)
  mapper:update(dt)
  p:update(dt)
end

function love.draw()
  love.graphics.push()

  local x, y = p.b:getPosition()

	local tx = math.floor(x - love.graphics.getWidth()  / 2 )
	local ty = math.floor(y - love.graphics.getHeight() / 2 )

  local w, h = love.graphics.getDimensions()
  love.graphics.translate((p.offset.x), (p.offset.y))

	love.graphics.rotate(-(p.angle))
  
	love.graphics.translate(-tx, -ty)

  mapper:draw(-(p.offset.x), -(p.offset.y))

  p:drawShots()

  love.graphics.pop()

  p:draw()

  love.graphics.print('FPS: ' .. love.timer.getFPS(),
    32, h-30
  )
  love.graphics.print(
    'Memory: ' .. math.floor(collectgarbage 'count') .. 'kb',
    150, h-30
  )
end

function love.mousepressed(cx, cy)
  p:shot(cx, cy, World)
end

function love.resize(w, h)
  p:setOffset(w/2, h/2)
end

function love.keypressed(key)
end
