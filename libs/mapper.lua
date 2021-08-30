local Char = require('libs.Char')

local Mapper = {}

function Mapper:new()
  local mapper = {}

  setmetatable(mapper, self)
  self.__index = self
  self.path = 'nil'

  return mapper
end

function Mapper.load(self, world, map)
  local initialtime = love.timer.getTime( )
  if self.objects then
    for _, object in ipairs(self.objects) do
      object:destroy()
    end
  end
  local oldpath = self.path
  local tmp = love.filesystem.load('maps/'..map)(world, self.path)
  self.path = map
  self.buffer, self.tileset = tmp[1], tmp[2]
  self.quads, self.objects  = tmp[3], tmp[4]
  self.callbacks = tmp[5] or {}
  local spawn = tmp[6][oldpath]
  
  print("Time loading Map: " .. love.timer.getTime( ) - initialtime)
  return Char(world, spawn[1], spawn[2], 'Player')
end

function Mapper.draw(self, tx, ty)
  for y, row in ipairs(self.buffer) do
    for x, quad in ipairs(row) do
      love.graphics.draw(
        self.tileset, self.quads[quad],
        (x-1)*32+tx, (y-1)*32+ty
      )
    end
  end
  for _, object in ipairs(self.objects) do
    object:draw(tx, ty)
  end
end

function Mapper.update(self, dt)
  for _, object in ipairs(self.objects) do
    object:update(dt)
  end
  if self.callbacks['update'] then self.callbacks.update(dt) end
end

return setmetatable({}, {__call = function(_, ...) return Mapper:new(...) end})