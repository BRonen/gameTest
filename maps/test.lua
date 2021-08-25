local world = ...

local Rect = require('objects.shapes.Rect')
local Line = require('objects.shapes.Line')
local objects = {}
table.insert(objects, Rect:new(world, 100, 100, 150, 150))
table.insert(objects, Rect:new(world, 300, 300, 10, 10))
table.insert(objects, Rect:new(world, 100, 500, 50, 50))

local h, w = 19*32, 10*32
table.insert(objects, Line:new(world, 0, 0, 0, w))
table.insert(objects, Line:new(world, h, w, h, 0))
table.insert(objects, Line:new(world, h, 0, 0, 0))

local function StrToBuffer(string, dict)
  local initialtime = love.timer.getTime( )
  local buffer = {}
  local x, y = 1, 1
  --gmatch every line
  for row in string:gmatch("[^\n]+") do
    --if the y pos of buffer isnt an table
    if not buffer[y] then buffer[y] = {} end
    --gmatch every character
    for char in row:gmatch(".") do
      if char ~= ' ' then
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

local tilestring = [[
abababababababababa
abbababbbababbbabab
abababababababababa
ababababbbababababb
abbabbababbabbabbaa
ababbaabababbababab
]]

local buffer = StrToBuffer(
  tilestring, {
    a = 1,
    b = 2
  }
)

local tileset = love.graphics.newImage("assets/textures.png")
local quads = {
  love.graphics.newQuad(0, 0, 32, 32, tileset:getDimensions()),
  love.graphics.newQuad(32, 0, 32, 32, tileset:getDimensions())
}

return buffer, tileset, quads, objects
