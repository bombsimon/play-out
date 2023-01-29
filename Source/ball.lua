local BALL_SIZE <const> = 3

local gfx <const> = playdate.graphics

class("ball").extends()

function ball:init()
  self.ball = {
    x = CONST.DISPLAY_WIDTH / 2 - (BALL_SIZE / 2),
    y = CONST.DISPLAY_HEIGHT - 25,
    xspeed = 2,
    yspeed = -2,
    bounrces = 1,
    paddleHit = false,
  }
end

function ball:update()
  local ball = self.ball
  if ball.y + BALL_SIZE >= CONST.DISPLAY_HEIGHT then
    return true
  end

  if ball.x + BALL_SIZE >= CONST.DISPLAY_WIDTH or ball.x <= 0 then
    ball.xspeed = -ball.xspeed
    ball.bounrces = ball.bounrces + 1
  end

  if ball.y + BALL_SIZE >= CONST.DISPLAY_HEIGHT or ball.y <= 0 or ball.paddleHit then
    ball.yspeed = -ball.yspeed
    ball.bounrces = ball.bounrces + 1

    ball.paddleHit = false
  end

  ball.x += ball.xspeed
  ball.y += ball.yspeed
end

function ball:draw()
  local ball = self.ball
  gfx.fillCircleAtPoint(ball.x, ball.y, BALL_SIZE)
end

function ball:paddleHit(paddle)
  local ball = self.ball

  if self:overlap(
    paddle.paddle.x,
    paddle.paddle.x + paddle.paddle.width,
    paddle.paddle.y,
    paddle.paddle.y + paddle.paddle.height
  )
  then
    ball.paddleHit = true
  end
end

function ball:overlap(x1, x2, y1, y2)
  local ball = self.ball
  bx, by = ball.x, ball.y

  return bx >= x1 and bx <= x2 and by >= y1 and by <= y2
end
