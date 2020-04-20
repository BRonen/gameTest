
function character(path)

  local o = {state = "F", x = 34, y = 34}
  
  o.__index = o

  o.Spriteset, o.animation = love.filesystem.load(path)()
  
  function o:setState(state)
    self.state = state
  end
  
  function o:stop()
    self.animation[self.state]:gotoFrame(2)
    self.animation[self.state]:pause()
  end
  
  function o:resume()
    self.animation[self.state]:resume()
  end

  function o:draw()
    self.animation[self.state]:draw(
      self.Spriteset,
      self.x, self.y
    )
  end

  function o:Move(x, y)
    self.x, self.y = x, y
    return x, y
  end

  return o
end

function newAnimations(spriteset, spriteInfo, width, height)
  local animations = {}
  local g = anim8.newGrid(width, height, spriteset:getWidth(), spriteset:getHeight(), 0, 0)
  for _, grids in ipairs(spriteInfo) do
    animations[grids[1]] = anim8.newAnimation(g(grids[3],grids[2] ,2, grids[2]), grids[4])
  end
  return spriteset, animations
end
