local joysticks = {0}

function joysticks:init()
  self[1] = self[1] + 1
  return love.joystick.getJoysticks()[self[1]] or false
end

return joysticks --TODO
