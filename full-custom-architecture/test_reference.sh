#!/bin/bash

# $1 = .adf, $2 = .tpef
ttasim -a $1 -p $2 < test/input_command_ref.txt > test/dump_ref.txt
cat test/dump_ref.txt | sed 's/ / \n/g' > test/reference_output