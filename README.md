# VLX_Acid_Video

VLX_Acid_Video is a procedural video generator that leverages FFmpeg and Bash to create algorithmic visual patterns. It includes a Python-based HTTP streamer for live viewing of the generated content.

## Features

- **Procedural Generation**: Generate unique video patterns using various algorithms:
    - `urandom`: Raw entropy stream.
    - `fourier`: Tri-channel interference patterns using sine/cosine functions.
    - `fibonacci`: Golden ratio spiral-based mathematical visualizations.
    - `fractal`: Mandelbrot set visualization.
    - `seq`: Standard test source sequence.
- **Customizable**: Configure output resolution, frame rate, and duration.
- **Web Interface**: Automatically generates an HTML5 interface for playback.
- **Live Server**: Includes a simple Python HTTP server with caching disabled for immediate viewing.

## Prerequisites

To use this tool, ensure you have the following installed on your system:

- **FFmpeg**: The core engine used for video generation.
- **Python 3**: Required to run the streaming server.
- **Bash**: Required to execute the generation script.

## Usage

### 1. Start the Server

Start the Python HTTP server to serve the generated content. The server is configured to prevent caching, ensuring you always see the latest video.

```bash
python3 VLX_Acid_streamer.py
```

The server will start at `http://localhost:8000`.

### 2. Generate Video

Use the `VLX_Acid_Video.sh` script to generate a video.

```bash
./VLX_Acid_Video.sh -t <type> -s <widthxheight> -f <fps> -d <duration> [-save]
```

**Arguments:**

- `-t`: **Type** of generator (`urandom`, `seq`, `fibonacci`, `fourier`, `fractal`).
- `-s`: **Size** (resolution) in `WxH` format (e.g., `1280x720`).
- `-f`: **Frame Rate** (FPS) (integer between 1 and 60).
- `-d`: **Duration** in seconds.
- `-save`: (Optional) If specified, the output file `stream.webm` is preserved. If omitted, the file is deleted after generation (useful for testing generation without keeping the file, though `-save` is required to view it via the server).

### Examples

**Generate a Fibonacci pattern:**
Create a 10-second video at 640x480 resolution and 30 FPS, and save the output.

```bash
./VLX_Acid_Video.sh -t fibonacci -s 640x480 -f 30 -d 10 -save
```

**Generate a Fractal visualization:**
Create a 5-second fractal video at 1280x720 resolution and 24 FPS.

```bash
./VLX_Acid_Video.sh -t fractal -s 1280x720 -f 24 -d 5 -save
```

### Viewing Results

After generating the video with the `-save` flag, open `http://localhost:8000` in your web browser. The generated `index.html` will load and play the video.

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3). See the `LICENSE` file for details.
