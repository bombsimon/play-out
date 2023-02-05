game_name :=  "PlayOut.pdx"
simulator := "${PLAYDATE_SDK_PATH}/bin/Playdate Simulator.app"

run: build
    open "{{simulator}}" Output/{{game_name}}

build:
    pdc Source Output/{{game_name}}
