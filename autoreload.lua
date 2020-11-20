--[[

TODO:
 -[ ] do a recursive function that insert files in sub-folders too

]]

local ffi = require('ffi') --need to use luajit
local lfs = require('lfs') --need to install luafilesystem

local Files = {} --files on current file

local currentLove = assert(io.popen('love .', 'r')) --run first instance of love

local function restartLove()
  local pgrep = assert(io.popen('pgrep love', 'r')) --run ls
  local pid = pgrep:read('*all')

  print("restarting...")

  if pid then os.execute('kill '..pid) end
  pgrep:close()

  currentLove = assert(io.popen('love .', 'r'))  --run a new instance of love
end

local function updateFiles()
  local file = assert(io.popen('ls', 'r')) --run ls
  local output = file:read('*all')
  file:close()

  for k in string.gmatch(output, "(%a+)%p([l][u][a])") do --filter .lua files
    local err
    Files[k..".lua"], err = lfs.attributes(k..".lua")
    assert(err == nil)
  end
end

local function main()
  for path, data in pairs(Files) do
    local modification = data.modification
    local access = data.access
    local change = data.change
    local err

    data, err = lfs.attributes(path)
    assert(err == nil)

    if
      modification ~= data.modification or
      access ~= data.access or
      change ~= data.change
    then
      print('file modified: '..path)
      restartLove()
      Files[path] = data
    end
  end
end

ffi.cdef("unsigned int sleep(unsigned int seconds);") --use the C function sleep

updateFiles()
while true do
  main()
  ffi.C.sleep(2) --you can use os.execute('sleep 2') but cant use Ctrl+C to stop
end
