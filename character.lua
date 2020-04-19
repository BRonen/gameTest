function character(path)
  local o = {x = 0, y = 0}
  
  o.__index = o

  o.Sprites, o.Spriteset = love.filesystem.load(path)()

  function o:draw()
    love.graphics.draw(self.Spriteset, self.Sprites["F0"], self.x, self.y)
  end

  function o:Move(x, y)
    self.x, self.y = x, y
    return x, y
  end

  return o
end

function newSkin(spriteset, spriteInfo, width, height)
  local Sprites = {}

  for _,info in ipairs(spriteInfo) do
    Sprites[info[1]] = love.graphics.newQuad(info[2], info[3],
      width, height,
      Spriteset:getHeight(), Spriteset:getWidth()
    )
  end
  return Sprites, Spriteset
end
