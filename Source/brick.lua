local gfx <const> = playdate.graphics
local img <const> = playdate.graphics.image

local variants = {
  playdate.graphics.image.kDitherTypeDiagonalLine,
  playdate.graphics.image.kDitherTypeVerticalLine,
  playdate.graphics.image.kDitherTypeHorizontalLine,
  playdate.graphics.image.kDitherTypeScreen,
  playdate.graphics.image.kDitherTypeBayer2x2,
  playdate.graphics.image.kDitherTypeBayer4x4,
  playdate.graphics.image.kDitherTypeBayer8x8,
  playdate.graphics.image.kDitherTypeFloydSteinberg,
  playdate.graphics.image.kDitherTypeBurkes,
  playdate.graphics.image.kDitherTypeAtkinson,
}

class("brick").extends()

local brickTypeAlpha = {
  ["1"] = 0.4,
  ["2"] = 0.4,
  ["3"] = 0.4,
  ["4"] = 0.4,
  ["5"] = 0.4,
  ["6"] = 0.4,
  ["7"] = 0.4,
  ["8"] = 0.8,
  ["9"] = 0.4,
  ["10"] = 0.4,
}

function brick:init(x, y, width, height, variant)
  local variant = variant or 0
  local alpha = brickTypeAlpha[tostring(variant)]

  self.brick = {
    x = x,
    y = y,
    width = width or 40,
    height = height or 10,
    alpha = alpha,
    variant = variant,
  }
end

function brick:update()
  local brick = self.brick

  self:updateStyle()
end

function brick:collide()
  local brick = self.brick
  brick.variant -= 2

  return brick.variant < 1
end

function brick:draw()
  local brick = self.brick

  local offset = brick.height / 2

  playdate.graphics.setDitherPattern(brick.alpha, variants[brick.variant])
  gfx.fillCircleAtPoint(brick.x + offset, brick.y + offset, offset)
  gfx.fillCircleAtPoint(brick.x + brick.width - offset, brick.y + offset, offset)
  gfx.fillRect(brick.x + offset, brick.y, brick.width - offset * 2, brick.height)
  playdate.graphics.setColor(playdate.graphics.kColorBlack)
end

function brick:updateStyle()
  local brick = self.brick

  if playdate.buttonJustPressed(playdate.kButtonUp) then
    if brick.alpha < 1.0 then
      brick.alpha += 0.1
    end
  end

  if playdate.buttonJustPressed(playdate.kButtonDown) then
    if brick.alpha > 0.0 then
      brick.alpha -= 0.1
    end
  end

  local vVariants = #variants
  if playdate.buttonJustPressed(playdate.kButtonLeft) then
    if brick.variant == 1 then
      brick.variant = vVariants
    else
      brick.variant -= 1
    end
  end

  if playdate.buttonJustPressed(playdate.kButtonRight) then
    if brick.variant == vVariants then
      brick.variant = 1
    else
      brick.variant += 1
    end
  end
end

function brick:rect()
  local brick = self.brick

  return {
    x1 = brick.x,
    x2 = brick.x + brick.width,
    y1 = brick.y,
    y2 = brick.y + brick.height,
  }
end
