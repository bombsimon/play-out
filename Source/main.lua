import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")

import("game")
import("menu")

CONST = import("constants")

math.randomseed(playdate.getSecondsSinceEpoch())

local game = game()
setupMenu(game)

local function initalize()
  local fnt = playdate.graphics.font.new("fonts/Mini Mono/Mini Mono")
  playdate.graphics.setFont(fnt)

  playdate.display.setRefreshRate(CONST.REFRESH_RATE)
  playdate.display.setScale(CONST.SCALE)
end

initalize()

function playdate.update()
  game:update()
  game:draw()

  -- playdate.drawFPS(0, 0)
end
