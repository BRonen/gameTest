local Line = {}

function Line:new(world, x1, y1, x2, y2)
  local line = {}

  setmetatable(line, self)
  self.__index = self

  line.b = love.physics.newBody(world, 0, 0, 'static')
  line.s = love.physics.newEdgeShape( x1, y1, x2, y2 )
  line.f = love.physics.newFixture( line.b, line.s )

  line.color = {
    math.random(1, 255)/255,
    math.random(1, 255)/255,
    math.random(1, 255)/255
  }

  return line
end

function Line.update(self, dt)
  return
end

function Line.draw(self, tx, ty)
  tx = tx or 0
  ty = ty or 0
  local x, y, xx, yy = self.b:getWorldPoints(self.s:getPoints())
  
  love.graphics.setColor(self.color)
  love.graphics.line(x+tx, y+ty, xx+tx, yy+ty)
  love.graphics.setColor(1,1,1)
end

return Line