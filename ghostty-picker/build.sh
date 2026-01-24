#!/bin/bash

cd "$(dirname "$0")" || return
swiftc -O -o ghostty-picker main.swift && \
cp ghostty-picker "Ghostty Picker.app/Contents/MacOS/Ghostty Picker" && \
echo "Built: $(pwd)/Ghostty Picker.app"
