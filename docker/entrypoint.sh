#!/bin/bash
export WINEDEBUG=-all
export DISPLAY=:1.0

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

# Required Arguments
# wine \
args=( "${VRISING_PATH}/VRisingServer.exe" )
args+=( "-batchmode" )
args+=( "-nographics" )
args+=( "-persistentDataPath" "${VRISING_PATH}/save-data" )
args+=( "-logFile" "${VRISING_PATH}/logs/VRisingServer.log" )
args+=( "-serverName" "${SERVER_NAME}" )
args+=( "-description" "${DESCRIPTION}" )
args+=( "-gamePort" "${GAME_PORT}" )
args+=( "-queryPort" "${QUERY_PORT}" )
args+=( "-bindAddress" "${BIND_ADDRESS}" )
args+=( "-hideIpAddress" "${HIDE_IP}" )
args+=( "-lowerFPSWhenEmpty" "${LOWER_FPS_EMPTY}" )
args+=( "-secure" "${SECURE}" )
args+=( "-listOnEOS" "${EOS_LIST}" )
args+=( "-listOnSteam" "${STEAM_LIST}" )
args+=( "-saveName" "${SAVE_NAME}" )

# Optional Arguments
if [[ -n "${SERVER_PASSWORD:-}" ]]; then
  args+=( "-password" "${SERVER_PASSWORD}" )
fi

if [[ -n "${GAME_PRESET:-}" ]]; then
  args+=( "-preset" "${GAME_PRESET}" )
fi

if [[ -n "${DIFFICULTY:-}" ]]; then
  args+=( "-difficultyPreset" "${DIFFICULTY}" )
fi

# Install/Update V Rising
echo "$(timestamp) INFO: Updating V Rising Dedicated Server"
steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$VRISING_PATH" +login anonymous +app_update ${STEAM_APP_ID} validate +quit

# Check that steamcmd was successful
if [ $? != 0 ]; then
    echo "$(timestamp) ERROR: steamcmd was unable to successfully initialize and update V Rising"
    exit 1
fi

# Redirect log file to stdout
echo "$(timestamp) INFO: Linking log file to standard out"
ln -sf /proc/1/fd/1 "${VRISING_PATH}/logs/VRisingServer.log"

# Start xvfb 
echo "$(timestamp) INFO: Starting X11 emulation"
Xvfb :1 -screen 0 1024x768x16 &

# Start VRising
echo "$(timestamp) INFO: Launching V Rising"
exec wine "${args[@]}"