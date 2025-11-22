#!/bin/bash
set -e

THEME_NAME="theme"
OUTDIR="$THEME_NAME/cursors"

ls fdr/*.ani | xargs -n1 ani2png-rs

declare -A MAP=(
    ["standard Pointer"]="left_ptr"
    ["alternate"]="left_ptr_watch" 
    ["busy"]="wait" 
    ["working"]="progress" 
    ["link pointer"]="pointer" 
    ["help pointer"]="help" 
    ["precision pointer"]="crosshair" 
    ["handwriting"]="pencil" 
    ["unavailable"]="not-allowed" 
    ["text"]="text" 
    ["horizontal"]="ew-resize" 
    ["top bottom"]="cross" 
    ["top"]="ns-resize" 
    ["diag 1"]="nw-resize" 
    ["diag 2"]="sw-resize" 
)

echo "creating theme directory at $OUTDIR"
mkdir -p "$OUTDIR"

for d in */; do
    d="${d%/}"
 
    if [[ ! -d "$d" ]]; then
        continue
    fi

    if [[ -z "${MAP[$d]}" ]]; then
        echo "skipping unknown folder: $d"
        continue
    fi

	off=$(grep -oba $'anih' "${d}.ani" | head -n1 | cut -d: -f1)

	if [ -z "$off" ]; then
	    echo "error: ${d}.ani has no 'anih' header"
	    exit 1
	fi

	fpos=$((off + 4 + 0x20))

	j=$(dd if="${d}.ani" bs=1 skip="$fpos" count=4 2>/dev/null \
	    | od -An -t u4)

	j=$(echo "$j")

	if [ "$j" -eq 0 ]; then
	    echo "error: ${d}.ani has framerate=0 or invalid"
	    exit 1
	fi

	j=$((1000 / j))

    cursor_name="${MAP[$d]}"
    echo "processing: $d → $cursor_name"

    pushd "$d" > /dev/null

	for f in *.png; do
	    magick "$f" -define png:color-type=6 -alpha on -depth 8 "$f.clean"
	    mv "$f.clean" "$f"
	done

    echo "  building cursor.cfg…"
    rm -f cursor.cfg
    for f in *.png; do
        echo "32 1 1 $f $j" >> cursor.cfg
    done

    echo "  running xcursorgen…"
    xcursorgen cursor.cfg cursor

    popd > /dev/null

    mv "$d/cursor" "$OUTDIR/$cursor_name"
done

echo "adding aliases…"
cd "$OUTDIR"

ln -sf left_ptr arrow
ln -sf left_ptr default
ln -sf left_ptr top_left_arrow
ln -sf left_ptr dnd-move
ln -sf left_ptr move
ln -sf left_ptr top_left_corner
ln -sf nw-resize se-resize
ln -sf sw-resize ne-resize
ln -sf pointer hand2
ln -sf pointer hand1
ln -sf help question_arrow
ln -sf wait watch
ln -sf progress left_ptr_watch
ln -sf text xterm
ln -sf text vertical-text
ln -sf crosshair cross
ln -sf crosshair cross_reverse
ln -sf crosshair diamond_cross
ln -sf crosshair tcross
ln -sf not-allowed no-drop
ln -sf cross top_side
ln -sf cross bottom_side
ln -sf cross right_side
ln -sf cross left_side
ln -sf ns-resize sb_v_double_arrow
ln -sf ew-resize sb_h_double_arrow
ln -sf nw-resize bd_double_arrow
ln -sf nw-resize top_left_corner
ln -sf nw-resize bottom_right_corner
ln -sf sw-resize fd_double_arrow
ln -sf sw-resize top_right_corner
ln -sf sw-resize bottom_left_corner
ln -sf cross top_side
ln -sf cross bottom_side
ln -sf cross right_side
ln -sf cross left_side
ln -sf cross fleur
ln -sf cross all-scroll
ln -sf crosshair cell
ln -sf ns-resize row-resize
ln -sf ew-resize col-resize
ln -sf pointer top_left_arrow
ln -sf pointer context-menu


echo "done!"
