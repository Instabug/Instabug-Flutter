#!/bin/bash

DIR_DART="lib/src/generated"
DIR_IOS="ios/Classes/Generated"
DIR_ANDROID="android/src/main/java/com/instabug/flutter/generated"
PKG_ANDROID="com.instabug.flutter.generated"

mkdir -p $DIR_DART
mkdir -p $DIR_IOS
mkdir -p $DIR_ANDROID

generate_pigeon() {
  name_file=$1
  name_snake=$(basename $name_file .api.dart)
  name_pascal=$(echo "$name_snake" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')

  dart run pigeon \
      --input "pigeons/$name_snake.api.dart" \
      --dart_out "$DIR_DART/$name_snake.api.g.dart" \
      --objc_header_out "$DIR_IOS/${name_pascal}Pigeon.h" \
      --objc_source_out "$DIR_IOS/${name_pascal}Pigeon.m" \
      --java_out "$DIR_ANDROID/${name_pascal}Pigeon.java" \
      --java_package $PKG_ANDROID || exit 1;

  echo "Generated $name_snake pigeon"

  # Generated files are not formatted by default,
  # this affects pacakge score.
  dart format "$DIR_DART/$name_snake.api.g.dart"
}

for file in pigeons/**
do
  generate_pigeon $file
done
