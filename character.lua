local anim8 = require 'anim8'

function character(path, name)
  local char = {name=name, stop = true, state = "f"}

  local spriteInfo = {
    { 'b' , 9, '2-9', 0.1 },
    { 'l' , 10, '1-9', 0.2 },
    { 'f' , 11, '2-9', 0.1 },
    { 'r' , 12, '1-9', 0.2 }
  }

  char.spriteset = love.graphics.newImage(path)
  char.animation = newAnimations(char.spriteset, spriteInfo, 64, 64)

  function char:init(x, y)
    self.body = love.physics.newBody(World, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(14)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self.name)
    self.fixture:setRestitution(0.2)


    self.activater = {}
    self.activater.body = love.physics.newBody(World, x, y+28, "dynamic")
    self.activater.shape = love.physics.newCircleShape(10)
    self.activater.fixture = love.physics.newFixture(self.activater.body, self.activater.shape)
    self.activater.fixture:setUserData(self.name.."Activer")

    self.activater.update = {} --improve this

    self.activater.update["f"] = function(x,y)
      self.activater.body:setPosition(x, y+28)
    end
    self.activater.update["b"] = function(x,y)
      self.activater.body:setPosition(x, y-28)
    end
    self.activater.update["l"] = function(x,y)
      self.activater.body:setPosition(x-28, y)
    end
    self.activater.update["r"] = function(x,y)
      self.activater.body:setPosition(x+28, y)
    end
  end

  Colisoes[char.name] = function(target)
    print("in coll")
    colCallbacks = {}
    colCallbacks["Button"] = function() print("Player collision between with button") end

    for name, callback in pairs(colCallbacks) do
      print("callback test [ply]")
      if name == target then callback() end
    end
    print("on coll")
  end

  Colisoes[char.name.."Activer"] = function(target)
    print("in coll")
    colCallbacks = {}
    colCallbacks["Button"] = function() print("Activater collision between with button") end
    colCallbacks["Block"] = function() print("Activater collision between with button") end
    colCallbacks["Table"] = function() print("Activater collision between with table") end

    for name, callback in pairs(colCallbacks) do
      print("callback test [act]")
      if name == target then callback() end
    end
    print("on coll")
  end

  function char:setState(state)
    self.state = state
  end

  function char:stop()
    self.animation[self.state]:gotoFrame(1)
    self.animation[self.state]:pause()
  end

  function char:resume()
    self.animation[self.state]:resume()
  end

  function char:update(dt)

    self.body:setLinearVelocity(0, 0) --stop player
    self.activater.body:setLinearVelocity(0, 0) --stop player activater

    self.animation[self.state]:update(dt) --update animation (anim8)

    self:resume() --resume (if already resume, just do nothing)

    self:setState(self.move.direction) --update player's direction

    self.body:applyForce(self.move.vecX, self.move.vecY) --move player

    self.activater.update[self.state](self.body:getPosition()) --move player activater (check line 30)

    if self.move.vecX == 0 and self.move.vecY == 0 then --if stopped
      self:stop()
    end
    self.move.vecX, self.move.vecY = 0, 0 --reset velocity
  end

  char.move = {direction = "f", vecX=0, vecY=0} --improve this
  function char.move:right(dt)
    self.vecX = 700000*dt
    self.direction = "r"
  end
  function char.move:left(dt)
    self.vecX = -700000*dt
    self.direction = "l"
  end
  function char.move:up(dt)
    self.vecY = -700000*dt
    self.direction = "b"
  end
  function char.move:down(dt)
    self.vecY = 700000*dt
    self.direction = "f"
  end

  function char:draw()
    local x, y = self.body:getPosition()
    self.animation[self.state]:draw(
      self.spriteset,
      x-32, y-48
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
  return animations
end
