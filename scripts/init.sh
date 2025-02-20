#!/bin/bash

if [ -d "android" ]; then
    rm -rf "android"
    echo "Folder android and its contents removed"
fi

if [ -d "ios" ]; then
    rm -rf "ios"
    echo "Folder ios and its contents removed"
fi


if [ -d "build" ]; then
    rm -rf "build"
    echo "Folder build and its contents removed"
fi

if [ -d "lib" ]; then
    rm -rf "lib"
    echo "Folder lib and its contents removed"
fi

if [ -d "test" ]; then
    rm -rf "test"
    echo "Folder test and its contents removed"
fi

if [ -d "example" ]; then
    rm -rf "example"
    echo "Folder example and its contents removed"
fi

if command -v melos &> /dev/null
then
    echo "Melos found"
else
    echo "Melos not found"
    dart pub global activate melos &&  echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> $BASH_ENV
fi


melos bootstrap
melos dart_bootstrap
melos pigeon --no-select
melos generate --no-select
melos pods --no-select
