function setupMenu(game)
  local menu = playdate.getSystemMenu()

  local menuItem, error = menu:addMenuItem("restart game", function()
    game:init()
  end)
end
