#!/bin/bash
# merge.sh
# display command line options

count=1

for param in "@@"; do
    echo " -------------------- "
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1))
done
