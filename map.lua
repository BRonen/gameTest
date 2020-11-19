local map = {}
local canvas
local canvasImg

function map:new(path)
  local time = love.timer.getTime( )
  if World then World:destroy() end
  World = love.physics.newWorld()

  local tileString, quadInfo = love.filesystem.load(path)()
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
      self.TileTable[columnIndex][rowIndex] = character --set tiles into tile table
      columnIndex = columnIndex + 1
      
      if character == "#" then --if wall
        table.insert( Statics, createStatic( --add static blocks to collid
          "Block",
          ((columnIndex-1)*32)-16, (rowIndex*32)-16,
          TileW-2, TileH-2
        ) ) --add static blocks to collid
      end 
      
    end --for character in row
    
    rowIndex=rowIndex+1
  end --for row in tile string
  
  canvas = love.graphics.newCanvas(
    (#(self.TileTable))*TileH,
    (#(self.TileTable[1]))*TileW
  )
  love.window.setMode(
    (#(self.TileTable))*TileH,
    (#(self.TileTable[1]))*TileW
  )
  
  canvas:renderTo(function()
    for x,column in ipairs(self.TileTable) do
      for y,char in ipairs(column) do
        love.graphics.draw(
          self.Tileset, self.Quads[ char ],
          (x-1)*TileW, (y-1)*TileH
        )
      end
    end
  end) --set render function to canvas
  
  canvasImg = love.graphics.newImage(
    canvas:newImageData( )
  )
  if Debug then print("Loading map: " .. love.timer.getTime( ) - time) end
end

function map:draw()
  love.graphics.draw(canvasImg) --render canvas
end

return map --TODO: *REFACTORY*
