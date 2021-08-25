local anim8 = require('libs.anim8')
local Char = {}

function Char:new(world, x, y)
  local char = {}
  
  setmetatable(char, self)
  self.__index = self

  char.b = love.physics.newBody(world, x, y, 'dynamic')
  char.b:setMass(1)
  char.s = love.physics.newRectangleShape(22,28)
  char.f = love.physics.newFixture(char.b, char.s)

  char.angle = 0

  local w, h = love.graphics.getDimensions()
  char.offset = {
    x = w/2,
    y = h/2
  }

  char.Shots = {}

  char.animstate = 'n'

  char.spriteset = love.graphics.newImage('assets/Player.png')
  local g = anim8.newGrid(
    25, 32,
    char.spriteset:getWidth(),
    char.spriteset:getHeight(),
    0, 1, 0
  )
  local anim = {}
  anim['s'] = anim8.newAnimation(g('1-3',1, 2, 1), 0.2)
  anim['w'] = anim8.newAnimation(g('1-3',2, 2, 2), 0.2)
  anim['e'] = anim8.newAnimation(g('1-3',3, 2, 3), 0.2)
  anim['n'] = anim8.newAnimation(g('1-3',4, 2, 4), 0.2)

  char.anim = anim

  return char
end

function Char.setOffset(self, ox, oy)
  local w, h = love.graphics.getDimensions()
  self.offset = {
    x = w/2,
    y = h/2
  }
end

function Char.draw(self)
  local x, y = self.offset.x, self.offset.y
  local w, h = 20, 28
  self.anim[self.animstate]:draw(
    self.spriteset,
    x-w/2-3, y-h/2-3
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

  --get the direction like 'nw', 'se' or just 'n'
  local direction = {}

  if love.keyboard.isDown('w') then direction[1] = 'n' end
  if love.keyboard.isDown('a') then direction[2] = 'w' end

  --if the already on oposite direction then the result is nil
  if love.keyboard.isDown('s') then
    if direction[1] then direction[1] = nil else direction[1] = 's' end
  end
  if love.keyboard.isDown('d') then
    if direction[2] then direction[2] = nil else direction[2] = 'e' end
  end

  --if walking in any direction
  if direction[1] or direction[2] then
    --update animation and resume if paused
    self.anim[self.animstate]:update(dt)
    self.anim[self.animstate]:resume()

    --direction in string like 'nw' or 's'
    local dirstr = ''..(direction[1] or '')..(direction[2] or '')

    --update animation
    if not (direction[1] and direction[2]) then
      self.animstate = dirstr
    end

    --get angle by direction
    local axis = directionToAxis[dirstr]
    self:move(vel, axis)

  else
    --stop animation when stop walking
    self.anim[self.animstate]:gotoFrame(2)
    self.anim[self.animstate]:pause()

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

return Char