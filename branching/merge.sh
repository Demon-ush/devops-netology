#!/bin/bash
# merge.sh
# display command line options

count=1
<<<<<<< HEAD
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1))
=======

for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
>>>>>>> 98a77ec... git-rebase 1
done
