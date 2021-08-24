local anim8 = require('libs.anim8')
local Char = {}

function Char:new(world, x, y)
  local char = {}
  
  setmetatable(char, self)
  self.__index = self

  char.b = love.physics.newBody(world, x-5/2, y-5/2, 'dynamic')
  char.b:setMass(1)
  char.s = love.physics.newCircleShape(5)
  char.f = love.physics.newFixture(char.b, char.s)

  local w, h = love.graphics.getDimensions()
  char.angle = 0
  char.offset = {
    x = w/2,
    y = h/2
  }

  char.Shots = {}

  char.state = {actual = 'f', prev = 'f'}

  char.spriteset = love.graphics.newImage('assets/Player.png')
  local g = anim8.newGrid(
    25, 32,
    char.spriteset:getWidth(),
    char.spriteset:getHeight(),
    0, 1, 0
  )
  local anim = {}
  anim['f'] = anim8.newAnimation(g('1-3',1, 2, 1), 0.2)
  anim['l'] = anim8.newAnimation(g('1-3',2, 2, 2), 0.2)
  anim['r'] = anim8.newAnimation(g('1-3',3, 2, 3), 0.2)
  anim['b'] = anim8.newAnimation(g('1-3',4, 2, 4), 0.2)

  char.anim = anim

  return char
end

function Char.draw(self)
  local x, y = self.offset.x, self.offset.y
  local r = self.s:getRadius()
  self.anim[self.state.actual]:draw(
    self.spriteset,
    x-12, y-22
  )
  love.graphics.circle('line', x, y, r)
  
  local vec = {
    x = math.cos(self.angle),
    y = math.sin(self.angle)
  }

  love.graphics.line(x, y, x, y-1*50)
end

function Char.update(self, dt)
  self.anim[self.state.actual]:update(dt)
  self.b:setLinearVelocity(0,0)
  local vel = 150*dt
  if love.keyboard.isDown('w') then
    self:move(vel, -90)
  end
  if love.keyboard.isDown('a') then
    self:move(-vel)
  end
  if love.keyboard.isDown('s') then
    self:move(-vel, -90)
  end
  if love.keyboard.isDown('d') then
    self:move(vel)
  end
  if love.keyboard.isDown('q') then
    self:rotate(-2)
  end
  if love.keyboard.isDown('e') then
    self:rotate(2)
  end
end

function Char.rotate(self, angle)
  self.angle = self.angle + math.rad(angle)
end

function Char.move(self, vel, axis)
  local angle = self.angle
  if axis then 
    angle = angle + math.rad(axis)
  end
  local vec = {
    x = math.cos(angle),
    y = math.sin(angle)
  }

  local mag = math.sqrt(vec.x * vec.x + vec.y * vec.y)

  vec.x = vec.x * vel / mag
  vec.y = vec.y * vel / mag

  self.b:setLinearVelocity(vec.x*100, vec.y*100)
end

function Char.shot(self, cx, cy, world)
  local px, py = self.b:getPosition()

  --Translates real click position
  cx = cx + math.floor(px - love.graphics.getWidth() / 2)
  cy = cy + math.floor(py - love.graphics.getHeight() / 2)

  --Rotate coords
  local angle = math.atan2(cy-py, cx-px)

  --vectors to mouse from player
  local vec = {
    x = math.cos(angle + self.angle),
    y = math.sin(angle + self.angle)
  }

  --fix collision of shot with player
  local x = vec.x < 0 and -5 or 5
  local y = vec.y < 0 and -5 or 5

  local shot = {}
  shot.b = love.physics.newBody(world, px + x, py + y, "dynamic")
  shot.s = love.physics.newCircleShape(5)
  shot.f = love.physics.newFixture(shot.b, shot.s)
  shot.f:setUserData('PlayerShot')
  shot.b:applyForce(vec.x*3000, vec.y*3000)

  table.insert(self.Shots, shot)
end

return Char