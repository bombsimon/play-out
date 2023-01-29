local gfx <const> = playdate.graphics

class("paddle").extends()

function paddle:init(width)
  local paddleWidth = width or 40

  self.paddle = {
    x = CONST.DISPLAY_WIDTH / 2 - (paddleWidth / 2),
    y = CONST.DISPLAY_HEIGHT - 20,
    crankSpeed = 5,
    width = paddleWidth,
    height = 10,
  }
end

function paddle:rect()
  local paddle = self.paddle

  return {
    x1 = paddle.x,
    x2 = paddle.x + paddle.width,
    y1 = paddle.y,
    y2 = paddle.y + paddle.height,
  }
end

function paddle:update()
  local paddle = self.paddle
  crankChange = playdate.getCrankChange() / paddle.crankSpeed

  paddle.x += crankChange
end

function paddle:draw()
  local paddle = self.paddle
  gfx.fillRect(paddle.x, paddle.y, paddle.width, paddle.height)
end
