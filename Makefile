GAME_NAME =  PlayOut.pdx
SIMULATOR ?= "${PLAYDATE_SDK_PATH}/bin/Playdate Simulator.app"

.PHONY: run
run: output
	open $(SIMULATOR) Output/$(GAME_NAME)

.PHONY: output
output:
	pdc Source Output/$(GAME_NAME)
