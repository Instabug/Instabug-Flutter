mkdir -p lib/generated
mkdir -p android/src/main/java/com/instabug/flutter/generated
mkdir -p ios/Classes/Generated

flutter pub run pigeon \
  --input pigeons/bug_reporting.api.dart \
  --dart_out lib/generated/bug_reporting.api.g.dart \
  --objc_header_out ios/Classes/Generated/BugReportingPigeon.h \
  --objc_source_out ios/Classes/Generated/BugReportingPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/BugReportingPigeon.java \
  --java_package "com.instabug.flutter.generated"

flutter pub run pigeon \
  --input pigeons/instabug.api.dart \
  --dart_out lib/generated/instabug.api.g.dart \
  --objc_header_out ios/Classes/Generated/InstabugPigeon.h \
  --objc_source_out ios/Classes/Generated/InstabugPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/InstabugPigeon.java \
  --java_package "com.instabug.flutter.generated"

flutter pub run pigeon \
  --input pigeons/instabug_log.api.dart \
  --dart_out lib/generated/instabug_log.api.g.dart \
  --objc_header_out ios/Classes/Generated/InstabugLogPigeon.h \
  --objc_source_out ios/Classes/Generated/InstabugLogPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/InstabugLogPigeon.java \
  --java_package "com.instabug.flutter.generated"
