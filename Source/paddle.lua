local DISPLAY_WIDTH <const> = playdate.display.getWidth()
local DISPLAY_HEIGHT <const> = playdate.display.getHeight()
local PADDLE_WIDTH <const> = 40
local PADDLE_HEIGHT <const> = 10

local gfx <const> = playdate.graphics

class("paddle").extends()

function paddle:init()
  self.paddle = {
    x = DISPLAY_WIDTH / 2 - (PADDLE_WIDTH / 2),
    y = DISPLAY_HEIGHT - 20,
  }
end

function paddle:update()
  local paddle = self.paddle
  crankChange = playdate.getCrankChange() / 5

  paddle.x += crankChange
end

function paddle:draw()
  local paddle = self.paddle
  gfx.fillRect(paddle.x, paddle.y, PADDLE_WIDTH, PADDLE_HEIGHT)
end
