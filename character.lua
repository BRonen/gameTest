
function calculate(x, xx, y, yy)
  return math.sqrt(((xx-x)^2) + ((yy-y)^2))
end

function character(path)

  local char = {stop = true, state = "F"}

  char.Spriteset, char.animation = love.filesystem.load(path)()
  
  function char:reset(x, y)
  self.b = love.physics.newBody(World, x, y, "dynamic")
  self.s = love.physics.newRectangleShape(20,20)
  self.f = love.physics.newFixture(player.b, player.s)
  self.f:setUserData("Player")
  self.f:setRestitution(0.2)
  end
  
  function char:setState(state)
    self.state = state
  end

  function char:stop()
    self.animation[self.state]:gotoFrame(2)
    self.animation[self.state]:pause()
  end

  function char:resume()
    self.animation[self.state]:resume()
  end

  function char:draw()
    local x, y = self.b:getPosition()
    self.animation[self.state]:draw(
      self.Spriteset,
      x-12, y-20
    )
  end
  
  function char:test(door)
    local x, y = self.b:getPosition()
    if calculate(x, door.x, y, door.y) <= 32 then
      door.open()
    end
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
