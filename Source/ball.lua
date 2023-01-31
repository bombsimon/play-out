local BALL_SIZE <const> = 3
local INITIAL_SPEED <const> = 3

local gfx <const> = playdate.graphics

class("ball").extends()

function ball:init()
  self.ball = {
    x = CONST.DISPLAY_WIDTH / 2 - (BALL_SIZE / 2),
    y = CONST.DISPLAY_HEIGHT - 25,
    speed = INITIAL_SPEED,
    xspeed = 0,
    yspeed = -INITIAL_SPEED,
    bounces = 1,
  }
end

function ball:reset(x, y)
  local ball = self.ball

  ball.x = x
  ball.y = CONST.DISPLAY_HEIGHT - 25
  ball.xspeed = 0
  ball.yspeed = INITIAL_SPEED
end

function ball:update()
  local ball = self.ball
  if ball.y + BALL_SIZE >= CONST.DISPLAY_HEIGHT then
    return true
  end

  if ball.x + BALL_SIZE >= CONST.DISPLAY_WIDTH or ball.x <= 0 then
    ball.xspeed = -ball.xspeed
  end

  if ball.y + BALL_SIZE >= CONST.DISPLAY_HEIGHT or ball.y <= 0 then
    ball.yspeed = -ball.yspeed
  end

  ball.x += ball.xspeed
  ball.y += ball.yspeed
end

function ball:draw()
  local ball = self.ball
  gfx.fillCircleAtPoint(ball.x, ball.y, BALL_SIZE)
end

function ball:redirectY()
  local ball = self.ball
  ball.yspeed = -ball.yspeed
end

function ball:redirect(side, ratio)
  local ball = self.ball
  local newXSpeed = ball.speed * ratio
  if side == -1 then
    newXSpeed = -newXSpeed
  end

  local newYSpeed = ball.speed - ratio
  if ball.yspeed > 0 then
    newYSpeed = -newYSpeed
  end

  ball.xspeed = newXSpeed
  ball.yspeed = newYSpeed
end
