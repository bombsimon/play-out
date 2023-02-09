function setupMenu(game)
  local menu = playdate.getSystemMenu()

  local menuItem, error = menu:addMenuItem("restart game", function()
    game:init()
  end)

  local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("random", false, function(value)
    game.randomMode = value
  end)
end
