local Mapper = {}

function Mapper:new(world)
  local initialtime = love.timer.getTime( )
  local mapper = {}

  setmetatable(mapper, self)
  self.__index = self
  
  self.buffer, self.tileset, self.quads, self.objects = love.filesystem.load('maps/test.lua')(world)

  print("Time loading map: " .. love.timer.getTime( ) - initialtime)
  return mapper
end

function Mapper.draw(self, tx, ty)
  for y, row in ipairs(self.buffer) do
    for x, quad in ipairs(row) do
      love.graphics.draw(
        self.tileset, self.quads[quad],
        ((x-1)*32)+tx, ((y-1)*32)+ty
      )
    end
  end
  for _, object in ipairs(self.objects) do
    object:draw(tx, ty)
  end
end

local timer = 0
function Mapper.update(self, dt)
  timer = timer + dt
  if timer > 1 then
    timer = timer - 1
    table.insert(self.buffer, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1})
  end
  for _, object in ipairs(self.objects) do
    object:update(dt)
  end
end

return Mapper