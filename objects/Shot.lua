local anim8 = require('libs.anim8')

local Shot = {}

function Shot:new(world, x, y, r, a, spriteset)
  local shot = {}

  setmetatable(shot, self)
  self.__index = self
  
  shot.b = love.physics.newBody(world, x, y, 'dynamic')
  shot.s = love.physics.newCircleShape(r)
  shot.f = love.physics.newFixture(shot.b, shot.s)
  shot.f:setUserData('Shot')
  shot.r = r
  shot.a = a

  shot.spriteset = love.graphics.newImage('assets/'..spriteset)
  local g = anim8.newGrid(
    10, 14,
    shot.spriteset:getWidth(),
    shot.spriteset:getHeight(),
    1, 1
  )
  shot.anim = anim8.newAnimation(g('2-3',1, 3,1, 1,1), 0.3)

  return shot

end

function Shot.update(self, dt)
  self.anim:update(dt)
end

function Shot.draw(self, tx, ty)
  tx = tx or 0
  ty = ty or 0
  local x, y = self.b:getPosition()
  --love.graphics.setColor(self.color)
  --love.graphics.circle('line', x + tx, y + ty, self.r)
  self.anim:draw(self.spriteset, x + tx, y + ty, self.a)
  --love.graphics.setColor(1,1,1)
end

function Shot.destroy(self)
  self.f:destroy()
  self.b:destroy()
  self.s:release()
end

return setmetatable({}, {__call = function(_, ...) return Shot:new(...) end})