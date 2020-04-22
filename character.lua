
function character(path)

  local char = {stop = true, state = "F"}
  
  char.__index = char

  char.Spriteset, char.animation = love.filesystem.load(path)()
  
  function char:setState(state)
    self.state = state
  end

  function char:draw()
    local x, y = self.b:getPosition()
    self.animation[self.state]:draw(
      self.Spriteset,
      x-12, y-16
    )
  end

  return char
end

function newAnimations(spriteset, spriteInfo, width, height)
  local animations = {}
  local g = anim8.newGrid(width, height, spriteset:getWidth(), spriteset:getHeight(), 0, 0)
  for _, grids in ipairs(spriteInfo) do
    animations[grids[1]] = anim8.newAnimation(g(grids[3],grids[2] ,2, grids[2]), grids[4])
  end
  return spriteset, animations
end
