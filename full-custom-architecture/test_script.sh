#!/bin/bash

# $1 = .adf, $2 = .tpef, $3 output file
ttasim -a $1 -p $2 < test/input_command.txt > test/dump.txt
cat test/dump.txt | sed 's/ / \n/g' > test/modified.txt
output=$(diff -u test/reference_output test/modified.txt)
# Check if the output is empty
if [ -z "$output" ]; then
    echo "TEST SUCCESSFUL"
else
    echo -e "FAILURE\n\n"
    echo "Reference                           Current run"
    pr -m -t test/reference_output test/modified.txt
fi
