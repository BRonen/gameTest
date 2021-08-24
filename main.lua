local Char = require('libs.Char')

local mapper = require('libs.mapper'):new()

local Line = require('objects.shapes.Line')
local Rect = require('objects.shapes.Rect')

local World = love.physics.newWorld(0, 0)
local Walls = {}

local p

function love.load(args)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.Globals = {}
  local w, h = love.graphics.getDimensions()
  print('RESOLUTION: ', w, h)
  p = Char:new(World, w/2, h/2)
  table.insert(Walls, Line:new(World, 0, 0, 0, w))
  table.insert(Walls, Line:new(World, 0, w, h, w))
  table.insert(Walls, Line:new(World, h, w, h, 0))
  table.insert(Walls, Line:new(World, h, 0, 0, 0))
  table.insert(Walls, Rect:new(World, 100, 100, 150, 150))
end

function love.update(dt)
  Event:update(dt)
  World:update(dt)
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

  mapper:draw((p.offset.x), (p.offset.y))

  for _, line in ipairs(Walls) do
    line:draw()
  end
  for _, shot in ipairs(p.Shots) do
    local x, y = shot.b:getPosition()
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', x-400, y-300, 5)
    love.graphics.setColor(255, 255, 255)
  end

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

function love.keypressed(key)
end
