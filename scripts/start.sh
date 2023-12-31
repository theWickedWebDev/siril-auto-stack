#!/bin/bash
set -a               
source $STACK_HOME/scripts/util/c.sh
set +a

echo "📷 ${BOLD}${GREEN}Starting Stack${NORMAL} 📷" && echo ""

function printDirDetails() {
    printf "%-22s%s%b\n" "${DIM}Working directory:${NORMAL} $1"
    LIGHTS_COUNT="$(ls -1q $LIGHTS_PATH/* | wc -l) ${BLUE}Lights${NORMAL}"
    FLATS_COUNT="$(ls -1q $FLATS_PATH/* | wc -l) ${BLUE}Flats${NORMAL}"
    DARKS_COUNT="$(ls -1q $DARKS_PATH/* | wc -l) ${BLUE}Darks${NORMAL}"
    printf "%-29s%8s%4s%10s%6s%4s%10s%6s%4s" "${DIM}Contains:${NORMAL}" "$LIGHTS_COUNT" "" "$FLATS_COUNT" "" "$DARKS_COUNT" && echo ''
}

function delaystart() {
    for i in $(seq $1 -1 0);do
        echo "Starting in ${i}s..."
        sleep 1
    done
}

# Intro
printDirDetails $WORKING_DIRECTORY
# delaystart 3

if [ -n "$NOVERIFY" ]; then
    echo "Skipping verifications"
else
    # Run Validations
    . $STACK_HOME/scripts/validation/check.sh
fi

function get_exif_val_from_first_file() {
  FIRST_FRAME="$1/$(ls $1 | grep "cr2" | head -1)"
  v=$(sed "s/:\ /:/g" <<< "$(exiftool -s2 -$2 "$FIRST_FRAME")")
  echo $v
}

. $STACK_HOME/scripts/preprocess.sh
# . $STACK_HOME/scripts/post-remove-green.sh -d $dir/stacked/ -f stacked-lights.fit -c $CONFIG_DIR &&
# . $STACK_HOME/scripts/post-preview-autostretch.sh -d $dir/stacked/ -f nogreen-stacked-lights.fit -c $CONFIG_DIR
