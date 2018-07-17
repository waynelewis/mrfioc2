#!/bin/bash

if [ ${#@} == 0 ]; then
echo " "
echo "    This script checks the updates in this folder and recursive directories the last X days"
echo "    Usage:"
echo "    $ ./check_updates param1"
echo "    * param1: number of days"
echo " "

else
find . -type f -mtime -$1 -exec ls -a {} \; | more
fi
