mkdir -p lib/generated
mkdir -p android/src/main/java/com/instabug/flutter/generated
mkdir -p ios/Classes/Generated

flutter pub run pigeon \
  --input pigeons/instabug.api.dart \
  --dart_out lib/generated/instabug.api.g.dart \
  --objc_header_out ios/Classes/Generated/InstabugPigeon.h \
  --objc_source_out ios/Classes/Generated/InstabugPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/InstabugPigeon.java \
  --java_package "com.instabug.flutter.generated"
