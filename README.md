# VLX_Acid_Video

VLX_Acid_Video is a procedural video generator that leverages FFmpeg and Bash to create algorithmic visual patterns. It supports various mathematical and chaotic generators, along with a stackable modifier system for real-time visual effects.

## Features

- **Procedural Generation**: Generate unique video patterns using various algorithms:
    - `urandom`: Raw entropy stream.
    - `seq`: Standard test source sequence.
    - `fibonacci`: Golden ratio spiral-based mathematical visualizations.
    - `fourier`: Tri-channel interference patterns using sine/cosine functions.
    - `fractal`: Mandelbrot set visualization.
    - `perlin`: Organic clouds/smoke using Perlin noise.
    - `reaction`: Reaction-Diffusion patterns (stripes/mazes).
    - `voronoi`: Voronoi cellular/mosaic patterns.
    - `chaos`: Lorenz/Chaos orbits visualization.
    - `life`: Conway's Game of Life simulation.
- **Visual Modifiers**: Apply effects like zoom, hue shift, pixelation, and edge detection.
- **Customizable**: Configure output resolution, frame rate, and duration.
- **Streaming Support**: Stream directly to RTSP, SRT, or other FFmpeg-supported protocols.

## Prerequisites

To use this tool, ensure you have the following installed on your system:

- **FFmpeg**: The core engine used for video generation.
- **Bash**: Required to execute the generation script.
- **Git**: Required for the self-update feature.

## Usage

Use the `VLX_Acid_Video.sh` script to generate a video.

```bash
./VLX_Acid_Video.sh -t <type> -s <widthxheight> -f <fps> [-d <duration>] [modifiers] [-stream <url> | -save [filename]]
```

### Arguments

- `-t <type>`: **Type** of generator (`urandom`, `seq`, `fibonacci`, `fourier`, `fractal`, `perlin`, `reaction`, `voronoi`, `chaos`, `life`).
- `-s <WxH>`: **Size** (resolution) in `WxH` format (e.g., `1280x720`).
- `-f <fps>`: **Frame Rate** (FPS) (integer between 1 and 60).
- `-d <sec>`: **Duration** in seconds (optional). If omitted, the script runs indefinitely until interrupted (Ctrl+C).
- `-stream <url>`: Stream to the specified URL (e.g., `rtsp://localhost:8554/mystream` or `srt://...`).
- `-save [file]`: Save output to a file. If no filename is provided, a default `AcidVideo_<type>_...webm` file is created.
- `--update`: Self-update the script from GitHub (must be used as the only argument).

*Note: `-stream` and `-save` are mutually exclusive.*

### Modifiers

You can combine multiple modifiers to alter the visual output. They are applied in a preset order.

- `-luma`: Enable Luma Keying (transparency based on brightness).
- `-hue`: Enable Dynamic Hue Shift.
- `-tint`: Enable Color Tint.
- `-vignette`: Enable Vignette effect.
- `-zoom`: Enable Dynamic Zoom.
- `-lagfun`: Enable Lagfun (trails/decay).
- `-pixelate`: Enable Pixelation (Mosaic).
- `-edge`: Enable Edge Detection.

## Examples

**Generate a Fibonacci pattern saved to file:**
Create a 10-second video at 640x480 resolution and 30 FPS.

```bash
./VLX_Acid_Video.sh -t fibonacci -s 640x480 -f 30 -d 10 -save
```

**Stream a Reaction-Diffusion pattern with modifiers:**
Stream indefinitely to a local RTSP server with zoom and hue shift effects.

```bash
./VLX_Acid_Video.sh -t reaction -s 1280x720 -f 60 -zoom -hue -stream rtsp://localhost:8554/live
```

**Generate a Game of Life simulation with pixelation:**
Run a Game of Life simulation with a pixelated look.

```bash
./VLX_Acid_Video.sh -t life -s 800x600 -f 24 -pixelate -save output.webm
```

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3). See the `LICENSE` file for details.
