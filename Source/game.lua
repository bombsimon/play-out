class("game").extends()

import("ball")
import("paddle")
import("brick")

local gfx <const> = playdate.graphics
local img <const> = playdate.graphics.image

function game:init()
  self.lives = CONST.NUMBER_OF_LIVES
  self.state = CONST.STATE.RUNNING
  self.ball = ball()
  self.paddle = paddle()

  self.bricks = {}

  for row = 0, 5 do
    local topPadding = row * 15

    for i = 0, 6 do
      local spacing = i * 10
      local pos = spacing + i * 40

      table.insert(self.bricks, brick(25 + pos, 40 + topPadding, 40, 10, row + 1))
    end
  end
end

function game:update()
  for idx, brick in ipairs(self.bricks) do
    brick:update()

    if overlapsRect(self.ball.ball.x, self.ball.ball.y, brick:rect()) then
      table.remove(self.bricks, idx)

      self.ball:redirectY()
    end
  end

  self.paddle:update()

  local overlapped, side, ratio = overlapsRect(self.ball.ball.x, self.ball.ball.y, self.paddle:rect())
  if overlapped then
    self.ball:redirect(side, ratio)
  end

  if self.ball:update() then
    self.state = CONST.STATE.GAME_OVER
  end
end

function game:draw()
  gfx.clear()

  if self.state == CONST.STATE.RUNNING then
    self:drawGame()
  else
    local endText = "GAME OVER!"
    local textWidth = playdate.graphics.getTextSize(endText)

    gfx.drawText(endText, CONST.MID_X - (textWidth / 2) / CONST.SCALE, CONST.MID_Y)
    playdate.stop()
  end
end

function game:drawGame()
  for _, brick in ipairs(self.bricks) do
    brick:draw()
  end

  self.paddle:draw()
  self.ball:draw()
end

function overlapsRect(x, y, rect)
  if not (x >= rect.x1 and x <= rect.x2 and y >= rect.y1 and y <= rect.y2) then
    return false, 0.0
  end

  local rectLength = rect.x2 - rect.x1
  local rectMiddle = rectLength / 2
  local normalizedX = x - rect.x1
  local ratio = 1.0
  local side = 0 -- -1 left, 0 = middle, 1 = right

  if normalizedX < rectMiddle then
    ratio = normalizedX / rectMiddle
    side = -1
  elseif normalizedX > rectMiddle then
    ratio = 1 - ((normalizedX - rectMiddle) / rectMiddle)
    side = 1
  end

  return true, side, (1 - ratio)
end
