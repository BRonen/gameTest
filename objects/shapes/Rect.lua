local Rect = {}

function Rect:new(world, x, y, w, h)
  local rect = {}

  setmetatable(rect, self)
  self.__index = self
  
  rect.b = love.physics.newBody(world, x+w/2, y+h/2, 'static')
  rect.s = love.physics.newRectangleShape(w, h)
  rect.f = love.physics.newFixture(rect.b, rect.s)
  rect.x, rect.y = x, y
  rect.w, rect.h = w, h

  rect.color = {
    math.random(1, 255)/255,
    math.random(1, 255)/255,
    math.random(1, 255)/255
  }

  return rect
end

function Rect.update(self, dt)
end

function Rect.draw(self, tx, ty)
  tx = tx or 0
  ty = ty or 0
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x+tx, self.y+ty, self.w, self.h)
  love.graphics.setColor(1,1,1)
end

return Rect