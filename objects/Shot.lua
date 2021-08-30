local anim8 = require('libs.anim8')

local Shot = {}

function Shot:new(world, x, y, a, spriteset, name)
  name = name or ''
  local shot = {}

  setmetatable(shot, self)
  self.__index = self
  
  shot.b = love.physics.newBody(world, x, y, 'dynamic')
  shot.b:setMass(1)
  shot.s = love.physics.newCircleShape(3)
  shot.f = love.physics.newFixture(shot.b, shot.s)
  shot.f:setUserData(name..'Shot')
  shot.r = 3
  shot.a = a

  shot.spriteset = love.graphics.newImage('assets/'..spriteset)
  local g = anim8.newGrid(
    64, 64,
    shot.spriteset:getWidth(),
    shot.spriteset:getHeight(),
    1, 1
  )
  shot.anim = anim8.newAnimation(g('4-8',1), 0.1)
  shot.deading = anim8.newAnimation(g('3-1',1), 0.15)
  
  Event:subscribe(shot.f, function(event)
    local infos, a, b = event[4], event[1], event[2]
    --if neither of obj is the owner of shot and
    if (infos[1] ~= name and infos[2] ~= name) and
    --Shots dont target themselves
    (infos[1] ~= name..'Shot' or infos[2] ~= name..'Shot') then
      --update animation to exploded
      shot.anim = shot.deading
      Timer:after(0.45, function()
        shot:destroy()
      end)
    end
  end)

  return shot

end

function Shot.update(self, dt)
  self.anim:update(dt)
end

function Shot.draw(self, tx, ty)
  tx = (tx or 0) + math.sin(self.a) * 16
  ty = (ty or 0) - math.cos(self.a) * 16

  local x, y = self.b:getPosition()

  love.graphics.circle('line',
    x + tx - math.sin(self.a) * 16,
    y + ty + math.cos(self.a) * 16,
    self.r
  )
  self.anim:draw(self.spriteset, x + tx, y + ty, self.a, 0.5, 0.5)

end

function Shot.destroy(self)
  if not self.f:isDestroyed() then
    self.f:destroy()
    self.b:destroy()
    self.s:release()
    self.draw = function() return end
    self.update = function() return end
  end
end

return setmetatable({}, {__call = function(_, ...) return Shot:new(...) end})