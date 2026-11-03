#!/bin/bash

for i in 1 2 3 4
do
    folder="Testcase$i"
    output="Testcase${i}Diff"

    if [ -d "$output" ]; then
        rm -r "$output"
    fi

    for file1 in "$folder"/Version*.1.txt
    do
        file2="${file1%.1.txt}.2.txt"
        name="${file1##*/}"
        name="${name%.1.txt}"

        if ! diff -q "$file1" "$file2" > /dev/null; then
            mkdir -p "$output"
            diff -u "$file1" "$file2" > "$output/${name}Diff.txt"
        fi
    done
done
