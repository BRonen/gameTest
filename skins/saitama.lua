spriteInfo = { 
  { 'F' , 1, '1-3', 0.5 },
  { 'L' , 2, '1-3', 0.5 },
  { 'R' , 3, '1-3', 0.5 },
  { 'B' , 4, '1-3', 0.5 }
}

Spriteset = love.graphics.newImage('/skins/saitama.png')

return newAnimations(Spriteset, spriteInfo, 25, 32)
