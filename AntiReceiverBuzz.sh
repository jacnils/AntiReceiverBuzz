#!/bin/sh
# AntiReceiverBuzz - Linux/BSD version
# For the macOS version, see AntiReceiverBuzz.app

[ -z "$EMPTY_FILE_PATH" ] && EMPTY_FILE_PATH=$HOME/.local/share/empty.wav
[ -z "$DELAY" ] && DELAY=5

download_wav() {
	[ ! -f "$(command -v wget)" ] && printf "%s" "Wget not found, exiting." && exit 1
	[ -f "$EMPTY_FILE_PATH" ] && printf "%s" "File already exists, no need to call this function." && exit 1
	mkdir -p $(dirname $EMPTY_FILE_PATH)
	wget -O $EMPTY_FILE_PATH https://github.com/jacnils/AntiReceiverBuzz/raw/refs/heads/master/AntiReceiverBuzz.app/Contents/Resources/empty.wav || return 1
}

[ ! -f "$EMPTY_FILE_PATH" ] && download_wav
[ ! -x "$(command -v aplay)" ] && printf "%s" "aplay not found, please install alsa-utils" && exit 1

main() {
	while true; do
		aplay "$EMPTY_FILE_PATH"
		sleep $DELAY
	done

	exit 0
}

main &
