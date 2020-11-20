local map = {}

function map:new(path)
  local time = love.timer.getTime( )
  if World then World:destroy() end
  World = love.physics.newWorld()

  local tileString, quadInfo, especialsInfo = love.filesystem.load(path)()
  self.Tileset = love.graphics.newImage(quadInfo.path)
  local tilesetW, tilesetH = self.Tileset:getWidth(), self.Tileset:getHeight()
  self.Quads, Statics.blocks = {}, {}

  for _,info in ipairs(quadInfo) do
    -- info[1] = the character, info[2] = x, info[3] = y
    self.Quads[info[1]] = love.graphics.newQuad(
      info[2], info[3],
      TileW,  TileH,
      tilesetW, tilesetH
    )--piece by piece in "dictionary"
  end

  self.TileTable = {}

  local lineWidth = #(tileString:match("[^\n]+"))

  for x = 1,lineWidth,1 do self.TileTable[x] = {} end

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do --for row in tile string
    assert(#row == lineWidth, 'Map is not aligned: width of row ' .. --test if map is formatted
      tostring(rowIndex) .. ' should be ' .. tostring(lineWidth) ..
      ', but it is ' .. tostring(#row)
    ) --test if map is formatted
    columnIndex = 1

    for character in row:gmatch(".") do --for character in row
      if character ~= "/" then
        self.TileTable[columnIndex][rowIndex] = character --set tiles into tile table
        columnIndex = columnIndex + 1

        if especialsInfo[character] then --if has especial properties
          especialsInfo[character](rowIndex, columnIndex)
        end
      end

    end --for character in row

    rowIndex=rowIndex+1
  end --for row in tile string

  map.canvas = love.graphics.newCanvas(
    (#(self.TileTable))*TileH,
    (#(self.TileTable[1]))*TileW
  )
  love.window.setMode(800, 600)

  map.canvas:renderTo(function()
    for x,column in ipairs(self.TileTable) do
      for y,char in ipairs(column) do
        love.graphics.draw(
          self.Tileset, self.Quads[ char ],
          (x-1)*TileW, (y-1)*TileH
        )
      end
    end
  end) --set render function to canvas

  map.canvasImg = love.graphics.newImage(
    map.canvas:newImageData( )
  )
  if Debug then print("Loading map: " .. love.timer.getTime( ) - time) end
end

function map:drawMap()
  love.graphics.draw(map.canvasImg) --render canvas
end
function map:drawMinimap()
  local x, y = Cam:toWorldCoords(
    800-16-map.canvasImg:getWidth()/10, --minimap width
    --map.canvasImg:getHeight()/10
    16--minimap height
  )

  --minimap width + playerX/10, minimap height + playerY/10
  local px, py = x+player.body:getX()/10, y+player.body:getY()/10

  love.graphics.draw(
    map.canvasImg,
    x, y, 0, 0.1, 0.1
  )
  love.graphics.rectangle("fill", px-2, py-2, 5, 5)
end

return map
