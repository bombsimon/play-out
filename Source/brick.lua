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

function brick:init(x, y, width, height, variant)
  self.brick = {
    x = x,
    y = y,
    alpha = 0.3,
    variant = variant or 0,
    width = width or 40,
    height = height or 10,
  }
end

function brick:update()
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

function brick:draw()
  local brick = self.brick

  gfx.drawText(brick.alpha, 30, 10)
  gfx.drawText(brick.variant, 60, 10)

  playdate.graphics.setDitherPattern(brick.alpha, variants[brick.variant])
  gfx.fillRect(brick.x, brick.y, brick.width, brick.height)
  playdate.graphics.setColor(playdate.graphics.kColorBlack)
end
