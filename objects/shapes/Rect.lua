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

  return rect
end

function Rect.draw(self)
  love.graphics.rectangle('line', self.x-400, self.y-300, self.w, self.h)
end

return Rect