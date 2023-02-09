C = {}

C.REFRESH_RATE = 50
C.SCALE = 1
C.DISPLAY_WIDTH = playdate.display.getWidth() / C.SCALE
C.DISPLAY_HEIGHT = playdate.display.getHeight() / C.SCALE
C.MID_X = C.DISPLAY_WIDTH / 2
C.MID_Y = C.DISPLAY_HEIGHT / 2
C.TOP_SPACING = 15

-- Player lifecycle
C.NUMBER_OF_LIVES = 3

-- State management
C.STATE = {
  RUNNING = 1,
  PAUSED = 2,
  GAME_OVER = 3,
  GAME_END = 4,
}

return C
