local anim8 = require 'anim8'

function character(path, name)
  local char = {name=name, stop = true, state = "f", activater = {}}

  local spriteInfo = {
    { 'f' , 1, '1-3', 0.1 },
    { 'l' , 2, '1-3', 0.1 },
    { 'r' , 3, '1-3', 0.1 },
    { 'b' , 4, '1-3', 0.1 }
  }--improve

  char.spriteset = love.graphics.newImage(path)
  char.animation = newAnimations(char.spriteset, spriteInfo, 25, 32)

  function char:init(x, y)
    self.body = love.physics.newBody(World, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(10)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self.name)
    self.fixture:setRestitution(0.2)
    
    colisoes[self.name] = {Block = function() print("pft") end}

    self.activater.body = love.physics.newBody(World, x, y+32, "dynamic")
    self.activater.shape = love.physics.newCircleShape(10)
    self.activater.fixture = love.physics.newFixture(self.activater.body, self.activater.shape)
    self.activater.fixture:setUserData(self.name.."Activer")
    
    colisoes[self.name .. "Activer"] = {Block = function() print("parede") end}

    self.activater.update = {} --improve this
    self.activater.update["f"] = function(x,y)
      self.activater.body:setPosition(x, y+25)
    end
    self.activater.update["b"] = function(x,y)
      self.activater.body:setPosition(x, y-25)
    end
    self.activater.update["l"] = function(x,y)
      self.activater.body:setPosition(x-25, y)
    end
    self.activater.update["r"] = function(x,y)
      self.activater.body:setPosition(x+25, y)
    end
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

  function char:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.activater.body:setLinearVelocity(0, 0)
    self.animation[self.state]:update(dt)
    self:resume()
    self:setState(self.move.direction)
    self.activater.update[self.state](self.body:getPosition())
    self.body:applyForce(self.move.vecX, self.move.vecY)
    if self.move.vecX == 0 and self.move.vecY == 0 then
      self:stop()
    end
    self.move.vecX, self.move.vecY = 0, 0
  end

  char.move = {direction = "f", vecX=0, vecY=0} --improve this
  function char.move:right(dt)
    self.vecX = 500000*dt
    self.direction = "r"
  end
  function char.move:left(dt)
    self.vecX = -500000*dt
    self.direction = "l"
  end
  function char.move:up(dt)
    self.vecY = -500000*dt
    self.direction = "b"
  end
  function char.move:down(dt)
    self.vecY = 500000*dt
    self.direction = "f"
  end

  function char:draw()
    local x, y = self.body:getPosition()
    self.animation[self.state]:draw(
      self.spriteset,
      x-12, y-21
    )
  end

  return char
end --TODO: REFACTORY

function newAnimations(spriteset, spriteInfo, width, height)
  local animations = {}
  local g = anim8.newGrid(width, height, spriteset:getWidth(), spriteset:getHeight(), 0, 0)
  for _, grids in ipairs(spriteInfo) do
    animations[grids[1]] = anim8.newAnimation(g(grids[3],grids[2] ,2, grids[2]), grids[4])
  end
  return animations
end
