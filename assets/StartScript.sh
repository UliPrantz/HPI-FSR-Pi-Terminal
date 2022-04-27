#!/bin/sh

BASE_DIR=~/FsrTerminal
RELEASE_FILE=/app.so

if test -f "$BASE_DIR$RELEASE_FILE"; then
    FLUTTER_PI_ARGS=--release
    echo "Running FsrTerminal in release mode!"
else 
    echo "Running FsrTerminal in debug mode!"
fi

(cd $BASE_DIR && flutter-pi $FLUTTER_PI_ARGS .)