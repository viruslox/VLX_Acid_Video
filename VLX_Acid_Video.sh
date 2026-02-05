#!/bin/bash

# Acid_video - Procedural Video Generator
# Usage: ./generate.sh -t <type> -s <widthxheight> -f <fps> -d <duration> [-stream <url> | -save [filename]]

OUTPUT=""
SAVE=false
STREAM=false
SAVE_NAME=""
STREAM_URL=""

usage() {
    echo "Usage: $0 -t [urandom|seq|fibonacci|fourier|fractal] -s [WxH] -f [1-60] -d [sec] [-stream <url> | -save [filename]]"
    exit 1
}

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t) TYPE="$2"; shift ;;
        -s) SIZE="$2"; shift ;;
        -f) FPS="$2"; shift ;;
        -d) DUR="$2"; shift ;;
        -stream)
            STREAM=true
            if [[ "$#" -gt 1 && "$2" != -* ]]; then
                STREAM_URL="$2"
                shift
            else
                echo "Error: -stream requires a URL argument."
                exit 1
            fi
            ;;
        -save)
            SAVE=true
            # Check if next argument exists and is not a flag
            if [[ "$#" -gt 1 && "$2" != -* ]]; then
                SAVE_NAME="$2"
                shift
            fi
            ;;
        *) usage ;;
    esac
    shift
done

# Validation logic
if [[ -z "$TYPE" || -z "$SIZE" || -z "$FPS" || -z "$DUR" ]]; then usage; fi
if [[ "$STREAM" == false && "$SAVE" == false ]]; then usage; fi
if [[ "$STREAM" == true && "$SAVE" == true ]]; then
    echo "Error: -stream and -save cannot be used together."
    usage
fi

if [[ ! "$SIZE" =~ ^[0-9]+x[0-9]+$ ]] || [ "$FPS" -lt 1 ] || [ "$FPS" -gt 60 ]; then
    echo "Error: Invalid dimensions or FPS out of range (1-60)."
    exit 1
fi

W=$(echo $SIZE | cut -d'x' -f1)
H=$(echo $SIZE | cut -d'x' -f2)

# Determine Outputs
if [ "$SAVE" = true ]; then
    if [ -z "$SAVE_NAME" ]; then
        SAVE_NAME="AcidVideo_${TYPE}_$(date +%Y-%m-%d_%H-%M-%S).webm"
    fi
    OUTPUT="$SAVE_NAME"
fi

if [ "$STREAM" = true ]; then
    OUTPUT="$STREAM_URL"
fi

# Generator definitions
case $TYPE in
    urandom)
        # Raw entropy stream
        INPUT="-f lavfi -i nullsrc=s=$SIZE:r=$FPS,format=rgb24,noise=all_strength=100:allf=t+u"
        ;;
    fourier)
        # Tri-channel interference patterns
        INPUT="-f lavfi -i nullsrc=s=$SIZE:r=$FPS,format=gray8 -f lavfi -i nullsrc=s=${W}x1:r=$FPS,format=gray8 -f lavfi -i nullsrc=s=1x${H}:r=$FPS,format=gray8 -filter_complex [1:v]geq=lum='128+127*sin(X/30+T)',scale=${W}x${H}:flags=neighbor,setsar=1[g];[2:v]geq=lum='128+127*cos(Y/30+T)',scale=${W}x${H}:flags=neighbor,setsar=1[b];[0:v]geq=lum='128+127*sin(hypot(X-W/2,Y-H/2)/20-T)'[r];[g][b][r]mergeplanes=map0s=0:map0p=0:map1s=1:map1p=0:map2s=2:map2p=0:format=gbrp[out] -map [out]"
        ;;
    fibonacci)
        # Golden ratio spiral-based math
        INPUT="-f lavfi -i nullsrc=s=$SIZE:r=$FPS -vf geq=r='128+120*sin(sqrt(X*X+Y*Y)*1.618-T)':g='128+120*sin(X*1.618+T)':b='128+120*sin(Y*1.618+T)'"
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

if [ "$STREAM" = true ]; then
    # Detect format based on protocol
    FMT=""
    if [[ "$OUTPUT" == srt://* ]]; then
        FMT="-f mpegts"
    elif [[ "$OUTPUT" == rtsp://* ]]; then
        FMT="-f rtsp"
    elif [[ "$OUTPUT" == rtsps://* ]]; then
        FMT="-f rtsp"
    fi
    # Stream with low latency settings
    ffmpeg -y $INPUT -t "$DUR" -c:v libx264 -preset ultrafast -tune zerolatency -pix_fmt yuv420p $FMT "$OUTPUT"
else
    # Save to file (keep original settings)
    ffmpeg -y $INPUT -t "$DUR" -c:v libvpx -cpu-used 4 -deadline realtime -pix_fmt yuv420p "$OUTPUT"
    echo "Video saved to $OUTPUT"
fi
