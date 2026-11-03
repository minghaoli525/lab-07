#!/bin/bash

all_pass=1

for i in 1 2 3 4
do
    folder="Testcase$i"
    output="Testcase${i}Diff"
    pass=1
    has_diff=0

    for file1 in "$folder"/Version*.1.txt
    do
        file2="${file1%.1.txt}.2.txt"
        name="${file1##*/}"
        name="${name%.1.txt}"
        result="$output/${name}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            has_diff=1

            if [ ! -f "$result" ]; then
                pass=0
            elif ! diff -u "$file1" "$file2" | tail -n +3 | cmp -s - <(tail -n +3 "$result"); then
                pass=0
            fi
        else
            if [ -f "$result" ]; then
                pass=0
            fi
        fi
    done

    if [ "$has_diff" -eq 1 ] && [ ! -d "$output" ]; then
        pass=0
    fi

    if [ "$has_diff" -eq 0 ] && [ -d "$output" ]; then
        pass=0
    fi

    if [ "$pass" -eq 1 ]; then
        echo "Testcase$i: PASS"
    else
        echo "Testcase$i: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]; then
    exit 0
else
    exit 1
fi

