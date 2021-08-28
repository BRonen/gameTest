local anim8 = require('libs.anim8')
local Char = {}

function Char:new(world, x, y, name)
  local char = {}
  
  setmetatable(char, self)
  self.__index = self

  char.b = love.physics.newBody(world, x, y, 'dynamic')
  char.b:setMass(1)
  char.s = love.physics.newRectangleShape(15,30)
  char.f = love.physics.newFixture(char.b, char.s)
  char.f:setUserData(name)

  char.angle = 0

  local w, h = love.graphics.getDimensions()
  char.offset = {
    x = w/2,
    y = h/2
  }

  char.Shots = {}

  --the char walking and waiting
  char.animstate = {'n', 'n'}

  char.spriteset = love.graphics.newImage('assets/RunSheet.png')
  local g = anim8.newGrid(
    32, 32,
    char.spriteset:getWidth(),
    char.spriteset:getHeight(),
    0, 1, 0
  )
  local anim = {}
  anim['n']  = anim8.newAnimation(g('1-8',1, '7-2',1), 0.1)
  anim['ne'] = anim8.newAnimation(g('1-8',2, '7-2',2), 0.1)
  anim['e']  = anim8.newAnimation(g('1-8',3, '7-2',3), 0.1)
  anim['se'] = anim8.newAnimation(g('1-8',4, '7-2',4), 0.1)
  anim['s']  = anim8.newAnimation(g('1-8',5, '7-2',5), 0.1)
  anim['sw'] = anim8.newAnimation(g('1-8',6, '7-2',6), 0.1)
  anim['w']  = anim8.newAnimation(g('1-8',7, '7-2',7), 0.1)
  anim['nw'] = anim8.newAnimation(g('1-8',8, '7-2',8), 0.1)

  char.anim = anim

  return char
end

function Char.setOffset(self, ox, oy)
  local w, h = love.graphics.getDimensions()
  self.offset = {
    x = (w/2)+ox,
    y = (h/2)+oy
  }
end

function Char.draw(self, scale)
  scale = scale or 1
  local x, y = self.offset.x/scale, self.offset.y/scale
  local w, h = 20, 28
  local state = self.animstate[2]
  if self.animstate[1] ~= '' then state = self.animstate[1] end
  self.anim[state]:draw(
    self.spriteset,
    x-w/2-5, y-h/2-5
  )
  
  love.graphics.rectangle('line', x-w/2, y-h/2, w, h)
end

function Char.drawShots(self)
  for _, shot in ipairs(self.Shots) do
    local x, y = shot.b:getPosition()
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', x-400, y-300, 5)
    love.graphics.setColor(255, 255, 255)
  end
end
 
local directionToAxis = {
  ['n']  = -90,
  ['e']  =   0,
  ['s']  =  90,
  ['w']  = 180,
  ['ne'] = -45,
  ['se'] =  45,
  ['sw'] = 135,
  ['nw'] = 225
}

function Char.update(self, dt)
  self.b:setLinearVelocity(0,0)

  local vel = 150*dt

  --if walking in any direction
  if self.animstate[1] ~= '' then
    --update animation and resume if paused
    self.anim[self.animstate[1]]:update(dt)
    self.anim[self.animstate[1]]:resume()

    --get angle by direction and move
    local axis = directionToAxis[self.animstate[1]]
    self:move(vel, axis)
  else
    --stop animation when stop walking
    self.anim[self.animstate[2]]:gotoFrame(4)
    self.anim[self.animstate[2]]:pause()
  end
end

function Char.setDirection(self, dirstr)
  --if player stopped and not already stopped then
  if dirstr == '' and self.animstate[1] ~= '' then
    --update the direction of player stopped
    self.animstate[2] = self.animstate[1]
  end
  self.animstate[1] = dirstr
end

function Char.getDirection(self)
  return self.animstate
end

function Char.rotate(self, angle)
  self.angle = self.angle + math.rad(angle)
end

function Char.move(self, vel, axis)
  axis = axis or 0
  local angle = self.angle + math.rad(axis)
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
  shot.b:applyForce(vec.x*3000, vec.y*3000)

  table.insert(self.Shots, shot)
end

return setmetatable({}, {__call = function(_, ...) return Char:new(...) end})