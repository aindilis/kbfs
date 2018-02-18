#!/bin/bash

# $1 = search
# $2 = file

git rev-list --all $2 | (
    while read revision; do
	git grep -F $1 $revision $2;
    done
)

