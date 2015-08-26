#!/bin/bash
# Check we have arguments
if [ $# -eq 0 ]
then
	echo "No arguments supplied"
	exit 1
fi
# Get the directory that this script resides in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# Loop through each node
for i in $(ls -1 $DIR/nodes | sed "s|.json$||")
do
	ssh $i $@
done
