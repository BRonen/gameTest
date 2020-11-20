
local tileString = [[
################################  ###
#           #                #      #
#           #  L[]R   L[]R   # L[]R #
#           #  L()R   L()R   # L()R #
#           #                #      #
#           #                ###  ###
#           #  L[]R   L[]R          #
#           #  L()R   L()R    L[]R  #
#                             L()R  #
#                                   #
#                                   #
#           #  L[]R   L[]R          #
#           #  L()R   L()R   ###  ###
#           #                #LL  RR#
#           #                #LL  RR#
#           #  L[]R   L[]R   #LL  RR#
#           #  L()R   L()R   #LL  RR#
#           #                #LL  RR#
###################    #########  ###
#           #                #      #
#           #  L[]R   L[]R   # L[]R #
#           #  L()R   L()R   # L()R #
#           #                #      #
#           #                ###  ###
#           #  L[]R   L[]R          #
#           #  L()R   L()R    L[]R  #
#                             L()R  #
#                                   #
#                                   #
#           #  L[]R   L[]R          #
#           #  L()R   L()R   ###  ###
#           #                #LL  RR#
#           #                #LL  RR#
#           #  L[]R   L[]R   #LL  RR#
#           #  L()R   L()R   #LL  RR#
#           #                #LL  RR#
#####################################
]]

TileW, TileH = 32, 32

local quadInfo = {
  { ' ',  0,  0 }, -- floor
  { '[', 32,  0 }, -- table top left
  { ']', 64,  0 }, -- table top right
  { '(', 32, 32 }, -- table bottom left
  { ')', 64, 32 }, -- table bottom right
  { 'L',  0, 32 }, -- chair on the left
  { 'R', 96, 32 }, -- chair on the right
  { '#', 96,  0 }  -- bricks
}

local especialsInfo = {}

especialsInfo['#'] = function(rowIndex, columnIndex)
  table.insert( Statics, createStatic( --add static blocks to collid
    "Block",
    ((columnIndex-1)*32)-16, (rowIndex*32)-16,
    TileW-2, TileH-2
  ) ) --add static blocks to collid
end

quadInfo.path = '/tiles/resto.png' --tileImagePath

return tileString, quadInfo, especialsInfo
