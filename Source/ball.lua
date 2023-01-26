import("CoreLibs/graphics")
import("CoreLibs/object")

local DISPLAY_WIDTH <const> = playdate.display.getWidth()
local DISPLAY_HEIGHT <const> = playdate.display.getHeight()
local BALL_SIZE <const> = 3

local gfx <const> = playdate.graphics

class("ball").extends()

function ball:init()
  self.ball = {
    x = DISPLAY_WIDTH / 2 - (BALL_SIZE / 2),
    y = DISPLAY_HEIGHT - 20,
    xspeed = 1,
    yspeed = -1,
    bounrces = 1,
  }
end

function ball:update()
  local ball = self.ball
  if ball.x + BALL_SIZE >= DISPLAY_WIDTH or ball.x <= 0 then
    ball.xspeed = -ball.xspeed
    ball.bounrces = ball.bounrces + 1
  end

  if ball.y + BALL_SIZE >= DISPLAY_HEIGHT or ball.y <= 0 then
    ball.yspeed = -ball.yspeed
    ball.bounrces = ball.bounrces + 1
  end

  ball.x += ball.xspeed
  ball.y += ball.yspeed
end

function ball:draw()
  local ball = self.ball
  gfx.fillCircleAtPoint(ball.x, ball.y, BALL_SIZE)
end
