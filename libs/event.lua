local eventHolder = {}

--queue of events
eventHolder.queue = require('libs.queue').new()
--array with callbacks for each event
eventHolder.callbacks = {}

function eventHolder:subscribe(subject, callback)
  if eventHolder.callbacks[subject] then
    table.insert(eventHolder.callbacks[subject], callback)
    return
  end
  eventHolder.callbacks[subject] = {callback}
end

function eventHolder:deleteSubject(subject)
  if not eventHolder.callbacks[subject] then
    return
  end
  eventHolder.callbacks[subject] = nil
end

function eventHolder:update(dt)
  local event = self.queue:lpop()
  while event do
      local listeners = self.callbacks[event[1]]
      if listeners then
        for _, callback in ipairs(listeners) do
          callback(event)
        end
      end
      event = self.queue:lpop()
  end
end

function eventHolder:emit(event)
  self.queue:rpush(event)
end

return setmetatable({}, {__call = function(_, ...) return eventHolder end})