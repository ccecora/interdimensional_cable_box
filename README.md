# Interdimensional Cable Box

A Raspberry Pi Zero W cyberdeck built into an old PC case that behaves like a TV. Channels are folders of videos; channel up/down cycles between them; playback position is saved per video so switching back resumes mid-stream. A retro OSD banner flashes the channel name on each switch.

## Hardware

- Raspberry Pi Zero W running Raspbian Trixie (KMS driver `vc4-kms-v3d`)
- 1024x728 HDMI monitor mounted vertically (portrait)
- PC case front panel (POWER SW, RESET SW, POWER LED, HDD LED) wired to the Pi's GPIO per [.context/cyberdeck-tv-design.md](.context/cyberdeck-tv-design.md)
- Screen rotation done via KMS scanout (`video=HDMI-A-1:rotate=90` in `/boot/config.txt`)

## How it works

- Videos live under `~/videos/channels/<channel-name>/` and are downloaded with `yt-dlp` in vertical 720p
- `mpv` plays each channel's folder as a looping playlist, with an IPC socket at `/tmp/mpv.sock`
- A single `tv.sh` daemon manages channel state, OSD overlays, and channel switches
- Control commands (`next`, `prev`, `quit`) are sent through a named pipe at `/tmp/tv_control`
- Per-channel playlist order, video index, and timestamp are persisted in `~/.tv_state.json`
- The OSD banner is rendered via mpv's `osd-overlay` IPC command using inline ASS (with `\frz90` to counter-rotate text against the KMS rotation)

## Control

Local aliases (set in `.zshrc`):

```
tv    # launch the daemon
tvn   # channel up
tvp   # channel down
tvq   # quit
```

Remote control over SSH:

```
ssh pi 'tv-remote.sh next'
ssh pi 'tv-remote.sh prev'
```

The daemon auto-launches on TTY1 via `.zshrc`. A physical USB controller is planned.

## Dependencies

- `mpv`
- `python3`
- `fonts-terminus` (`sudo apt install fonts-terminus`)

## Status

Design phase. See [.context/cyberdeck-tv-design.md](.context/cyberdeck-tv-design.md) for the full design doc, KMS/OSD findings, and open questions.
