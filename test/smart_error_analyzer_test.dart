import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/modules/crash_reporting.dart';
import 'package:instabug_flutter/src/modules/smart_error_analyzer.dart';
import 'package:instabug_flutter/src/models/error_analysis.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SmartErrorAnalyzer Tests', () {
    test('should analyze network error correctly', () async {
      final error = Exception('Network connection failed');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      
      expect(analysis.category.name, 'network');
      expect(analysis.severity.name, 'high');
      expect(analysis.suggestedSolutions.length, greaterThan(0));
      expect(analysis.estimatedFixTime, greaterThan(0));
      expect(analysis.errorMessage, contains('Network connection failed'));
    });
    
    test('should analyze database error correctly', () async {
      final error = Exception('Database query failed');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      
      expect(analysis.category.name, 'database');
      expect(analysis.severity.name, 'medium');
      expect(analysis.suggestedSolutions.length, greaterThan(0));
    });
    
    test('should analyze UI error correctly', () async {
      final error = Exception('Widget build failed');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      
      expect(analysis.category.name, 'ui');
      expect(analysis.severity.name, 'low');
      expect(analysis.suggestedSolutions.length, greaterThan(0));
    });
    
    test('should handle unknown error correctly', () async {
      final error = Exception('Unknown error occurred');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      
      expect(analysis.category.name, 'unknown');
      expect(analysis.severity.name, 'medium');
      expect(analysis.suggestedSolutions.length, greaterThan(0));
    });
    
    test('should generate correct fingerprint', () async {
      final error = Exception('Test error');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      
      final fingerprint = CrashReporting.generateFingerprint(analysis);
      
      expect(fingerprint, contains(analysis.category.name));
      expect(fingerprint, contains(analysis.severity.name));
    });

    test('should generate correct fingerprint', () async {
      final error = Exception('Test error');
      final analysis = await SmartErrorAnalyzer.analyzeError(error);

      final fingerprint = CrashReporting.generateFingerprint(analysis);

      expect(fingerprint, contains(analysis.category.name));
      expect(fingerprint, contains(analysis.severity.name));
    });

    test('should serialize and deserialize correctly', () async {
      final error = Exception('Test error');
      final original = await SmartErrorAnalyzer.analyzeError(error);
      
      final json = original.toJson();
      final restored = ErrorAnalysis.fromJson(json);
      
      expect(restored.category, original.category);
      expect(restored.severity, original.severity);
      expect(restored.suggestedSolutions, original.suggestedSolutions);
      expect(restored.estimatedFixTime, original.estimatedFixTime);
      expect(restored.errorMessage, original.errorMessage);
    });
  });
}
