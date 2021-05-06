#!/bin/bash
# rebase.sh
# display command line options

count=1
<<<<<<< HEAD
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1))
done
=======

for param in "$#"; do
    echo "\$* Parameter: $param"
    count=$(( $count + 1 ))
done

echo "======="

>>>>>>> 98a77ec... git-rebase 1
