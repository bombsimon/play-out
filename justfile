game_name :=  "PlayOut.pdx"
simulator := "${PLAYDATE_SDK_PATH}/bin/Playdate Simulator.app"
game_dir  := "${PLAYDATE_SDK_PATH}/Disk/Games"

# Run the game, ensure freshly built
run: build
    open "{{simulator}}" Output/{{game_name}}

# Build the game
build:
    pdc Source Output/{{game_name}}

# Install game on Playdate Simulator
install: build
    cp -r Output/{{game_name}} {{game_dir}}

# Uninstall game from Playdate Simulator
uninstall:
    rm -r {{game_dir}}/{{game_name}}

# Print this help text
help:
    @just -l
