class("game").extends()

import("text")
import("ball")
import("paddle")
import("brick")

local gfx <const> = playdate.graphics
local img <const> = playdate.graphics.image

local heart = img.new("images/heart")
local levels = json.decodeFile("resources/levels.json")

function game:init()
  self.lives = CONST.NUMBER_OF_LIVES
  self.state = CONST.STATE.PAUSED
  self.ball = ball()
  self.paddle = paddle()
  self.level = 1
  self.randomMode = false
  self.frame = 0

  self:loadLevel()
end

function game:loadLevel()
  self.bricks = {}

  local level = nil
  if self.randomMode then
    level = self:generateRandomLevel()
  else
    level = levels[tostring(self.level)]
    if level == nil then
      return false
    end
  end

  for i, row in ipairs(level) do
    local topPadding = -10 + i * 12

    for j, col in ipairs(row) do
      if col ~= 0 then
        local pos = -40 + j * 40
        print(pos)

        table.insert(self.bricks, brick(pos, 20 + topPadding, 40, 10, col))
      end
    end
  end

  return true
end

function game:generateRandomLevel()
  local level = {}
  local numberOfRows = math.random(1, 8)

  for i = 1, numberOfRows do
    cols = {}

    for j = 1, 10 do
      -- 50/50 chance we get an empty spot
      if math.random(0, 1) == 1 then
        col = 0
        table.insert(cols, 0)
      else
        col = math.random(0, 10)
        table.insert(cols, col)
      end
    end

    table.insert(level, cols)
  end

  return level
end

function game:update()
  self.frame += 1
  if self.frame >= 1000 then
    self.frame = 0
  end

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

    if not self:loadLevel() then
      self.state = CONST.STATE.GAME_END
    end
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

  if self.state == CONST.STATE.GAME_END then
    drawRows({
      "CONGRATULATIONS!",
      "",
      "You reached the last level - " .. self.level - 1,
      "Use the menu to restart the game",
    })
  elseif self.state == CONST.STATE.GAME_OVER then
    drawRows({
      "GAME OVER!",
      "",
      "You reached level " .. self.level,
      "Use the menu to restart the game",
    })

    heart:draw(CONST.MID_X - 10, CONST.MID_Y + midOffset)
    heart:draw(CONST.MID_X, CONST.MID_Y + midOffset)
    heart:draw(CONST.MID_X + 10, CONST.MID_Y + midOffset)
  else
    self:drawGame()
  end
end

function game:drawGame()
  gfx.drawLine(0, CONST.TOP_SPACING, CONST.DISPLAY_WIDTH, CONST.TOP_SPACING)

  gfx.drawText("LEVEL " .. self.level, 10, 5)
  if self.randomMode and math.fmod(self.frame, 100) < 50 then
    drawCenterX("RANDOM MODE", 5)
  end

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
