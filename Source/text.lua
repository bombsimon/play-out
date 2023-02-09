local gfx <const> = playdate.graphics

function drawRows(textRows)
  local midOffset = (#textRows * 10)

  for i, text in ipairs(textRows) do
    local textWidth = gfx.getTextSize(text) - 4

    gfx.drawText(text, CONST.MID_X - (textWidth / 2) / CONST.SCALE, (CONST.MID_Y - midOffset) + i * 10)
  end
end

function drawCenterX(text, y)
  local textWidth = gfx.getTextSize(text) - 4
  gfx.drawText(text, CONST.MID_X - (textWidth / 2) / CONST.SCALE, y)
end
