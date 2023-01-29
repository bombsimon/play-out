import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")

import("game")

CONST = import("constants")

local game = game()

local function initalize()
  playdate.display.setRefreshRate(CONST.REFRESH_RATE)
  playdate.display.setScale(CONST.SCALE)
end

initalize()

function playdate.update()
  game:update()
  game:draw()

  playdate.drawFPS(0, 0)
end
