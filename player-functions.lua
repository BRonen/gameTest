
function playerMove(x, y)
  x, y = x, y
  return x, y
end

function loadSkin(path, x, y)
  love.filesystem.load(path)()
end

function newSkin(spriteset, spriteInfo)
  Spriteset = spriteset
  Sprites = {}

  for _,info in ipairs(spriteInfo) do
    Sprites[info[1]] = love.graphics.newQuad(info[2], info[3], 32, 25, Spriteset:getHeight(), Spriteset:getWidth())
  end
  x, y = 0, 0
end

function drawPlayer()
  love.graphics.draw(Spriteset, Sprites["F0"], x, y)
end
