#!/bin/bash
# merge.sh
# display command line options

count=1

while [[ -n "$1" ]]; do
    echo " -------------------- "
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1))
    shift
done
