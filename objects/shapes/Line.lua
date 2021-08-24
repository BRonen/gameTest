local Line = {}

function Line:new(world, x1, y1, x2, y2)
  local line = {}

  setmetatable(line, self)
  self.__index = self

  line.b = love.physics.newBody(world, 0, 0, 'static')
  line.s = love.physics.newEdgeShape( x1, y1, x2, y2 )
  line.f = love.physics.newFixture( line.b, line.s )

  return line
end

function Line.draw(self)
  local x, y, xx, yy = self.b:getWorldPoints(self.s:getPoints())
  love.graphics.line(x-400, y-300, xx-400, yy-300)
end

return Line