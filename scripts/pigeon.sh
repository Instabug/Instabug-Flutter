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
  --input pigeons/crash_reporting.api.dart \
  --dart_out lib/generated/crash_reporting.api.g.dart \
  --objc_header_out ios/Classes/Generated/CrashReportingPigeon.h \
  --objc_source_out ios/Classes/Generated/CrashReportingPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/CrashReportingPigeon.java \
  --java_package "com.instabug.flutter.generated"

flutter pub run pigeon \
  --input pigeons/feature_requests.api.dart \
  --dart_out lib/generated/feature_requests.api.g.dart \
  --objc_header_out ios/Classes/Generated/FeatureRequestsPigeon.h \
  --objc_source_out ios/Classes/Generated/FeatureRequestsPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/FeatureRequestsPigeon.java \
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

flutter pub run pigeon \
  --input pigeons/surveys.api.dart \
  --dart_out lib/generated/surveys.api.g.dart \
  --objc_header_out ios/Classes/Generated/SurveysPigeon.h \
  --objc_source_out ios/Classes/Generated/SurveysPigeon.m \
  --java_out ./android/src/main/java/com/instabug/flutter/generated/SurveysPigeon.java \
  --java_package "com.instabug.flutter.generated"
