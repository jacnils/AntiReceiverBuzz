# AntiReceiverBuzz

Tiny app preventing unwanted noise on macOS with receivers & amplifiers.

## Why would you ever want this?

I've noticed that macOS seems to disable its audio subsystem after roughly 15 seconds of no playback, in order to save energy.
This seems great, right? The problem is, some audio receivers and amplifiers will emit horrible static noise that is very
unpleasant to listen to assuming that there is no input.

This hack solves this by continuisely playing an empty audio file. There should not be any noticeable quality loss or anything along those lines, because all this script does is run an empty WAV file.

## What operating systems are supported.

Tested on macOS 15.0 Sequoia, it works perfectly. It *should* work on any macOS version that provides the command-line utility `afplay`. There are also no dependencies, and it doesn't show up in macOS' media controls. Great!

## Where is the source code?

This is just a script, there is no source code to speak of.

## License

GNU General Public License v3.
