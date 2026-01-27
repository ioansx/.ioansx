#!/bin/bash

cd "$(dirname "$0")" || return
swiftc -O -o ghostty-picker main.swift && \
    cp ghostty-picker "Ghostty Picker.app/Contents/MacOS/Ghostty Picker" && \
    cp ghostty-picker ../bin/ && \
    echo "Built: $(pwd)/Ghostty Picker.app"
