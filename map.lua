local map = {}

function map:new(path)
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
          TileW, TileH
        ) )
      end --add static blocks to collid
      
    end --for character in row
    
    rowIndex=rowIndex+1
  end --for row in tile string
  
  love.window.setMode(
    (#(self.TileTable))*TileH,
    (#(self.TileTable[1]))*TileW
  ) --set size of window
  
end

function map:draw()
  for x,column in ipairs(self.TileTable) do
    for y,char in ipairs(column) do
      love.graphics.draw(
        self.Tileset, self.Quads[ char ],
        (x-1)*TileW, (y-1)*TileH
      )
    end
  end
end

return map --TODO: *REFACTORY*
