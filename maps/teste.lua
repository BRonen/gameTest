local world, path = ...

local spawnPoints = {
  ['test.lua'] = {10*32, 4*32},
  ['nil']      = {10*32, 4*32}
}

local bodies = world:getBodies( )

for _, body in ipairs(bodies) do
  local fixture = body:getFixtures()[1]
  if fixture:getUserData() == 'Player' then
    --set the player to spawnpoint
    local spawnPoint = spawnPoints[path]
    body:setPosition(spawnPoint[1], spawnPoint[2])
  end
end
  
local objects = {}


local Rect = require('objects.shapes.Rect')

local objCreators = {
  ['#'] = function(x, y)
    x = x-1
    y = y-1

    local wall = Rect(world,  x*32, y*32, 32, 32, 'Wall', {0.1, 0.1, 1, 0.3})

    Event:subscribe(wall.f, function(event)
      local a, b, userdatas, world = event[1], event[2], event[4], event[5]
      if userdatas[1] == 'PlayerShot' or
      userdatas[2] == 'PlayerShot' then
        local nearby = world:queryBoundingBox(
          (x*32)-32, (y*32)-32,
          (x*32)+32, (y*32)+32,
          function() return true end
        ) or {}
        for _, f in ipairs(nearby) do
          if not f:isDestroyed() then
            local b = f:getBody()
            print('get ', b)
          end
        end
      end
    end)

    return wall
  end
}

local function StrToBuffer(string, dict)
  --[[
    This function turn a tilestring like [
    #########
    #       #
    #       #
    ####$####
    #       #
    #########
    ] into a buffer table like {
      {1, 1, 1, 1, 1, 1, 1},
      {1, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 1},
      {1, 1, 1, 1, 1, 1, 1},
    }
  ]]
  local initialtime = love.timer.getTime( )
  local buffer = {}
  local x, y = 1, 1
  --gmatch every line
  for row in string:gmatch("[^\n]+") do
    --if the y pos of buffer isnt an table
    if not buffer[y] then buffer[y] = {} end
    --gmatch every character
    for char in row:gmatch(".") do
      --if is a objects then
      if objCreators[char] then
        table.insert(objects, objCreators[char](x, y))
      end
      buffer[y][x] = dict[char]
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  print("Time buffering map: " .. love.timer.getTime( ) - initialtime)
  return buffer
end

local tilestring = [[
##############################
#                            #
#                            #
#                            #
#                            #
#                            #
#############$$###############
#                            #
#                            #
#                            #
#                            #
#############$$###############
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
]]

local buffer = StrToBuffer(
  tilestring, {
    [' '] = 1,
    ['$'] = 2,
    ['#'] = 3
  }
)

local tileset = love.graphics.newImage("assets/textures.png")
local quads = {
  love.graphics.newQuad( 0, 0, 32, 32, tileset:getDimensions()),
  love.graphics.newQuad(32, 0, 32, 32, tileset:getDimensions()),
  love.graphics.newQuad(64, 0, 32, 32, tileset:getDimensions())
}

local callbacks = {}
function callbacks.update(dt)
  return
end

return {buffer, tileset, quads, objects, callbacks, spawnPoints}
