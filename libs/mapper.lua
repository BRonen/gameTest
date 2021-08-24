local Mapper = {}

function Mapper:new()
  local initialtime = love.timer.getTime( )
  local mapper = {}

  setmetatable(mapper, self)
  self.__index = self
  
  self.tileset = love.graphics.newImage("assets/textures.png")
  self.quads = {
    love.graphics.newQuad(0, 0, 32, 32, self.tileset:getDimensions()),
    love.graphics.newQuad(32, 0, 32, 32, self.tileset:getDimensions())
  }

  self.buffer = self:StrToBuffer(
    love.filesystem.lines("maps/test.map"),
    {a = 1, b = 2}
  )

  print("Time loading map: " .. love.timer.getTime( ) - initialtime)
  return mapper
end

function Mapper.StrToBuffer(self, string, dict)
  local initialtime = love.timer.getTime( )
  local buffer = {}
  local x, y = 1, 1
  --gmatch every line
  for row in string do
    --if the y pos of buffer isnt an table
    if not buffer[y] then buffer[y] = {} end
    --gmatch every character
    for char in row:gmatch(".") do
      if char ~= ' ' then
        print(x, y)
        buffer[y][x] = dict[char]
        x = x + 1
      end
    end
    y = y + 1
    x = 1
  end
  print("Time buffering map: " .. love.timer.getTime( ) - initialtime)
  return buffer
end

function Mapper.draw(self, tx, ty)
  for y, row in ipairs(self.buffer) do
    for x, quad in ipairs(row) do
      love.graphics.draw(
        self.tileset, self.quads[quad],
        ((x-1)*32)-tx, ((y-1)*32)-ty
      )
    end
  end
end

return Mapper