#!/bin/bash

# Acid_video - Procedural Video Generator
# Usage: ./generate.sh -t <type> -s <widthxheight> -f <fps> -d <duration> [-save]

OUTPUT="stream.webm"
SAVE=false

usage() {
    echo "Usage: $0 -t [urandom|seq|fibonacci|fourier|fractal] -s [WxH] -f [1-60] -d [sec] [-save]"
    exit 1
}

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t) TYPE="$2"; shift ;;
        -s) SIZE="$2"; shift ;;
        -f) FPS="$2"; shift ;;
        -d) DUR="$2"; shift ;;
        -save) SAVE=true ;;
        *) usage ;;
    esac
    shift
done

# Validation logic
if [[ -z "$TYPE" || -z "$SIZE" || -z "$FPS" || -z "$DUR" ]]; then usage; fi
if [[ ! "$SIZE" =~ ^[0-9]+x[0-9]+$ ]] || [ "$FPS" -lt 1 ] || [ "$FPS" -gt 60 ]; then
    echo "Error: Invalid dimensions or FPS out of range (1-60)."
    exit 1
fi

W=$(echo $SIZE | cut -d'x' -f1)
H=$(echo $SIZE | cut -d'x' -f2)

# Generate HTML5 Interface
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Acid_video Live</title>
    <style>
        body { background: #050505; color: #00ff00; font-family: monospace; text-align: center; margin-top: 50px; }
        video { border: 2px solid #333; box-shadow: 0 0 20px #00ff0033; max-width: 90vw; }
        .meta { margin-top: 20px; color: #888; }
    </style>
</head>
<body>
    <h2>ACID_VIDEO :: GENERATING [${TYPE^^}]</h2>
    <video controls autoplay muted><source src="$OUTPUT" type="video/webm"></video>
    <div class="meta">Config: $SIZE @ $FPS FPS | Duration: $DUR s</div>
</body>
</html>
EOF

# Generator definitions
case $TYPE in
    urandom)
        # Raw entropy stream
        INPUT="-f rawvideo -pix_fmt rgb24 -s $SIZE -r $FPS -i <(dd if=/dev/urandom bs=$((W*H*3)) count=$((FPS*DUR)) 2>/dev/null)"
        ;;
    fourier)
        # Tri-channel interference patterns
        INPUT="-f lavfi -i nullsrc=s=$SIZE:r=$FPS -vf \"geq=r='128+127*sin(sqrt(pow(X-W/2,2)+pow(Y-H/2,2))/20-T)':g='128+127*sin(X/30+T)':b='128+127*cos(Y/30+T)'\""
        ;;
    fibonacci)
        # Golden ratio spiral-based math
        INPUT="-f lavfi -i nullsrc=s=$SIZE:r=$FPS -vf \"geq=r='128+120*sin(sqrt(X*X+Y*Y)*1.618-T)':g='128+120*sin(X*1.618+T)':b='128+120*sin(Y*1.618+T)'\""
        ;;
    fractal)
        INPUT="-f lavfi -i mandelbrot=size=$SIZE:rate=$FPS"
        ;;
    seq)
        INPUT="-f lavfi -i testsrc=size=$SIZE:rate=$FPS"
        ;;
    *) echo "Unknown generator type."; usage ;;
esac

echo "Executing $TYPE engine..."
ffmpeg -y $INPUT -t "$DUR" -c:v libvpx -cpu-used 4 -deadline realtime -pix_fmt yuv420p "$OUTPUT"

[[ "$SAVE" = false ]] && rm -f "$OUTPUT" && echo "Cleanup complete." || echo "Video saved to $OUTPUT"
