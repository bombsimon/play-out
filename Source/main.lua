import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")

local gfx <const> = playdate.graphics

import("ball")
import("paddle")

local ball = ball()
local paddle = paddle()

local function initalize()
  playdate.display.setRefreshRate(50)
end

initalize()

local function updateGame()
  paddle:update()
  ball:update()
end

local function drawGame()
  gfx.clear()
  paddle:draw()
  ball:draw()
end

function playdate.update()
  updateGame()
  drawGame()
  playdate.drawFPS(0, 0)
end
