import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final data = NetworkData(
    url: "https://httpbin.org/get",
    method: "GET",
    requestContentType: "application/json",
    responseContentType: "application/json",
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(milliseconds: 100)),
    duration: 100,
    requestBody: 'request',
    responseBody: 'response',
    requestHeaders: {'Connection': 'keep-alive'},
    responseHeaders: {'Content-Type': 'text/plain'},
    status: 200,
  );

  test('[copyWith] should return an exact copy', () async {
    final newData = data.copyWith();
    expect(newData.toJson(), data.toJson());
  });

  test('[copyWith] should return an updated copy', () async {
    const url = 'https://httpbin.org/post';
    const method = 'POST';
    const contentType = 'text/plain';
    const requestBody = 'new request';
    const responseBody = 'new response';
    const requestHeaders = {'Connection': 'close'};
    const responseHeaders = {'Content-Type': 'application/json'};
    final startDate = DateTime.now().add(const Duration(days: 1));
    final endDate = startDate.add(const Duration(milliseconds: 200));
    const duration = 200;
    const status = 300;

    final newData = data.copyWith(
      url: url,
      method: method,
      requestBody: requestBody,
      requestHeaders: requestHeaders,
      responseBody: responseBody,
      responseHeaders: responseHeaders,
      duration: duration,
      requestContentType: contentType,
      responseContentType: contentType,
      startTime: startDate,
      endTime: endDate,
      status: status,
    );

    expect(newData.url, url);
    expect(newData.method, method);
    expect(newData.requestBody, requestBody);
    expect(newData.requestHeaders, requestHeaders);
    expect(newData.responseBody, responseBody);
    expect(newData.responseHeaders, responseHeaders);
    expect(newData.duration, duration);
    expect(newData.requestContentType, contentType);
    expect(newData.responseContentType, contentType);
    expect(newData.startTime, startDate);
    expect(newData.endTime, endDate);
    expect(newData.status, status);
  });

  test('[toMap] should return exact data in a map', () async {
    final map = data.toJson();

    expect(map['url'], data.url);
    expect(map['method'], data.method);
    expect(map['requestContentType'], data.requestContentType);
    expect(map['responseContentType'], data.responseContentType);
    expect(map['duration'], data.duration);
    expect(map['requestBody'], data.requestBody);
    expect(map['responseBody'], data.responseBody);
    expect(map['requestHeaders'], data.requestHeaders);
    expect(map['responseHeaders'], data.responseHeaders);
  });
}
