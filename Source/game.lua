class("game").extends()

import("ball")
import("paddle")
import("brick")

local gfx <const> = playdate.graphics
local img <const> = playdate.graphics.image

local heart = playdate.graphics.image.new("images/heart")
local levels = json.decodeFile("resources/levels.json")

function game:init()
  self.lives = CONST.NUMBER_OF_LIVES
  self.state = CONST.STATE.PAUSED
  self.ball = ball()
  self.paddle = paddle()
  self.level = 1

  self:loadLevel()
end

function game:loadLevel()
  self.bricks = {}
  local level = levels[tostring(self.level)]

  for i, row in ipairs(level) do
    local topPadding = i * 15

    for j, col in ipairs(row) do
      if col ~= 0 then
        local spacing = j * 5
        local pos = spacing + j * 40

        table.insert(self.bricks, brick(pos, 20 + topPadding, 40, 10, col))
      end
    end
  end
end

function game:update()
  -- if we're not running, allow moving paddle and ball until we start the game
  -- by pressing A.
  if self.state ~= CONST.STATE.RUNNING then
    self.paddle:update()
    self.ball:reset(self.paddle:getCenter())

    if playdate.buttonJustPressed(playdate.kButtonA) then
      self.state = CONST.STATE.RUNNING
    end

    return
  end

  -- if there are no more bricks we advance to the next level
  if #self.bricks == 0 then
    self.state = CONST.STATE.PAUSED
    self.level += 1
    self:loadLevel()
  end

  for idx, brick in ipairs(self.bricks) do
    brick:update()

    if overlapsRect(self.ball.ball.x, self.ball.ball.y, brick:rect()) then
      if brick:collide() then
        table.remove(self.bricks, idx)
      end

      self.ball:redirectY()
    end
  end

  self.paddle:update()

  local overlapped, side, ratio = overlapsRect(self.ball.ball.x, self.ball.ball.y, self.paddle:rect())
  if overlapped then
    self.ball:redirect(side, ratio)
  end

  if self.ball:update() then
    if self.lives == 1 then
      self.state = CONST.STATE.GAME_OVER
    else
      self.lives -= 1
      self.state = CONST.STATE.PAUSED
      self.ball:reset(self.paddle:getCenter())
    end
  end
end

function game:draw()
  gfx.clear()

  if self.state ~= CONST.STATE.GAME_OVER then
    self:drawGame()
  else
    local textRows = {
      "GAME OVER!",
      "",
      "You reached level " .. self.level,
      "Use the menu to restart the game",
    }

    local midOffset = (#textRows * 10)

    for i, text in ipairs(textRows) do
      local textWidth = playdate.graphics.getTextSize(text) - 4

      gfx.drawText(text, CONST.MID_X - (textWidth / 2) / CONST.SCALE, (CONST.MID_Y - midOffset) + i * 10)
    end

    heart:draw(CONST.MID_X - 10, CONST.MID_Y + midOffset)
    heart:draw(CONST.MID_X, CONST.MID_Y + midOffset)
    heart:draw(CONST.MID_X + 10, CONST.MID_Y + midOffset)
  end
end

function game:drawGame()
  gfx.drawLine(0, CONST.TOP_SPACING, CONST.DISPLAY_WIDTH, CONST.TOP_SPACING)

  gfx.drawText("LEVEL " .. self.level, 10, 5)

  for i = 1, self.lives do
    local leftPadding = i * 10
    heart:draw(CONST.DISPLAY_WIDTH - leftPadding - 10, 5)
  end

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
