local anim8 = require('libs.anim8')
local Shot = require('objects.Shot')

local Char = {}

function Char:new(world, x, y, name)
  local char = {}
  
  setmetatable(char, self)
  self.__index = self

  char.b = love.physics.newBody(world, x, y, 'dynamic')
  char.b:setMass(1)
  char.s = love.physics.newCircleShape(10)
  char.f = love.physics.newFixture(char.b, char.s)
  char.f:setUserData(name)
  print(name .. ' is created now')

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
  anim['n']  = anim8.newAnimation(g('1-8',1), 0.07)
  anim['ne'] = anim8.newAnimation(g('1-8',2), 0.07)
  anim['e']  = anim8.newAnimation(g('1-8',3), 0.07)
  anim['se'] = anim8.newAnimation(g('1-8',4), 0.07)
  anim['s']  = anim8.newAnimation(g('1-8',5), 0.07)
  anim['sw'] = anim8.newAnimation(g('1-8',6), 0.07)
  anim['w']  = anim8.newAnimation(g('1-8',7), 0.07)
  anim['nw'] = anim8.newAnimation(g('1-8',8), 0.07)

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
  local r = self.s:getRadius()
  local state = self.animstate[2]
  if self.animstate[1] ~= '' then state = self.animstate[1] end
  self.anim[state]:draw(
    self.spriteset,
    x-16, y-20
  )
  
  if DEBUG then
    love.graphics.circle("line", x, y, r)
  end
end

function Char.drawShots(self, scale)
  for _, shot in ipairs(self.Shots) do
    shot:draw(-(self.offset.x), -(self.offset.y))
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
  for _, shot in ipairs(self.Shots) do
    shot:update(dt)
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

function Char.shot(self, world)
  local dir = self.animstate[1]
  if dir == '' then dir = self.animstate[2] end
  local angleCorretion = -math.rad(directionToAxis[dir])

  --vectors to mouse from player
  local vec = {
    x = math.cos(self.angle-angleCorretion),
    y = math.sin(self.angle-angleCorretion)
  }

  --fix collision of shot with player
  local x = vec.x < 0 and -5 or 5
  local y = vec.y < 0 and -5 or 5

  local px, py = self.b:getPosition()

  local shot = Shot(world, px + x, py + y, 5, self.angle-angleCorretion+math.rad(90), 'shot.png')
  shot.b:applyForce(vec.x*1000, vec.y*1000)

  table.insert(self.Shots, shot)
  Timer:after(1, function()
    local shots = {}
    for _, oldShot in ipairs(self.Shots) do
      if oldShot ~= shot then
        table.insert(shots, oldShot)
      end
    end
    self.Shots = shots
    shot.f:destroy()
    shot.b:destroy()
    shot.s:release()
  end)
end

return setmetatable({}, {__call = function(_, ...) return Char:new(...) end})