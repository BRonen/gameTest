spriteInfo = { 
  { 'F0',  5,  0 }, -- floor 
  { 'F' , 32,  0 }, -- table top left
  { 'F1', 64,  0 }, -- table top right
  { 'L0',  0, 32 }, -- table bottom left
  { 'L' , 32, 32 }, -- table bottom right
  { 'L1', 64, 32 }, -- chair on the left
  { 'R0',  0, 64 }, -- chair on the right
  { 'R' , 32, 64 },  -- bricks
  { 'R1', 64, 64 },  -- bricks
  { 'B0',  0, 96 },  -- bricks
  { 'B' , 32, 96 },  -- bricks
  { 'B1', 64, 96 }  -- bricks
}

Spriteset = love.graphics.newImage('/skins/saitama.png')

return newSkin(Spriteset, spriteInfo, 32, 25)
