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
  self.bricks = {
    brick(20, 40, 40, 10, 1),
  }
end

function game:update()
  for _, brick in ipairs(self.bricks) do
    brick:update()
  end

  self.paddle:update()

  self.ball:paddleHit(self.paddle)
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
