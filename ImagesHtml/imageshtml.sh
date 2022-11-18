#!/usr/bin/bash

for f in ./*.jpg; do echo "^<img src="$f" /^>" >> all.html
done 