# gopro-tool

A tool to control GoPro webcam mode in Linux.

# Usage

The simplest use-case is making the GoPro webcam available to a streaming or
video-conferencing app (requires `ffmpeg` installed):
```
gopro-tool start device
```

Another common usage is to preview the webcam video feed (requires `vlc` installed):
```
gopro-tool start preview
```

Starting webcam mode with a lower resolution, to save bandwidth and use less
CPU; and a narrower field of view (FoV), to show less of the environment
surrounding you; can be achieved with something like:
```
gopro-tool 480p narrow device
```

Running the tool on the command line without arguments will print the list of
all available commands:
```
$ gopro-tool
usage: gopro-tool commands...

commands:
- 1080p: start webcam mode with 1080p resolution
- 480p: start webcam mode with 480p resolution
- 720p: start webcam mode with 720p resolution
- device: create v4l2 gopro device under /dev/video42 with ffmpeg (requires webcam mode to be previously started)
- linear: switch to linear field of view
- narrow: switch to narrow field of view
- preview: preview webcam in VLC (requires webcam mode to be previously started)
- start: start webcam mode with default resolution
- stop: stop webcam mode
- wide: switch to wide field of view

example:
  gopro-tool start device
    - starts webcam mode using default resolution and make it available to
      video conference or other software

  gopro-tool start linear device
    - starts webcam mode using default resolution and linear FoV, and make it
    available to video conference or other software

  gopro-tool 480p narrow device
    - starts webcam mode using default resolution and narrow FoV, and make
      it available to video conference or other software

  gopro-tool 1080p linear preview
    - starts webcam mode using 1080p resolution and wide FoV, launching VLC
      to preview the video feed

  gopro-tool stop
    - stop webcam mode
```

# Installation

## `apt-get` (Debian, Ubuntu...)
```
echo 'deb [trusted=yes] https://juchem.github.io/debian ./' \
  | sudo tee /etc/apt/sources.list.d/gopro-tool.list
sudo apt-get update
sudo apt-get install gopro-tool
```

## Manual
Just copy the script to some local directory and set the execute permissions on
it:

```
curl https://raw.githubusercontent.com/juchem/gopro-tool/main/gopro-tool \
  | sudo tee /usr/local/bin/gopro-tool > /dev/null \
  && sudo chmod +x /usr/local/bin/gopro-tool
```
