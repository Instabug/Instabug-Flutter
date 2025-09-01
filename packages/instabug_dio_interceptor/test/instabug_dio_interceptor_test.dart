import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_dio_interceptor/instabug_dio_interceptor.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_dio_interceptor_test.mocks.dart';
import 'mock_adapter.dart';

class MyInterceptor extends InstabugDioInterceptor {
  int requestCount = 0;
  int resposneCount = 0;
  int errorCount = 0;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    requestCount++;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    resposneCount++;
    super.onResponse(response, handler);
  }

  @override
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) {
    errorCount++;
    super.onError(err, handler);
  }
}

@GenerateMocks(<Type>[
  InstabugHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugHostApi();

  late Dio dio;
  late MyInterceptor instabugDioInterceptor;
  const appToken = '068ba9a8c3615035e163dc5f829c73be';

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    NetworkLogger.$setHostApi(mHost);
    when(mHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future<Map<String, bool>>.value(<String, bool>{
        'isW3cCaughtHeaderEnabled': true,
        'isW3cExternalGeneratedHeaderEnabled': true,
        'isW3cExternalTraceIDEnabled': true,
      }),
    );
    when(mHost.getNetworkBodyMaxSize()).thenAnswer(
          (_) => Future.value(10240),
    );
  });

  setUp(() {
    dio = Dio();
    dio.options.baseUrl = MockAdapter.mockBase;
    dio.httpClientAdapter = MockAdapter();
    final events = <InvocationEvent>[];
    instabugDioInterceptor = MyInterceptor();
    dio.interceptors.add(instabugDioInterceptor);
    Instabug.init(token: appToken, invocationEvents: events);
  });

  test('onResponse Test', () async {
    try {

      await dio.get<dynamic>('/test');
      // ignore: deprecated_member_use
    } on DioError {
      // ignor
    }

    expect(instabugDioInterceptor.requestCount, 1);
    expect(instabugDioInterceptor.resposneCount, 1);
    expect(instabugDioInterceptor.errorCount, 0);
  });

  test('onError Test', () async {
    try {
      await dio.get<dynamic>('/test-error');
      // ignore: deprecated_member_use
    } on DioError {
      // ignor
    }

    expect(instabugDioInterceptor.requestCount, 1);
    expect(instabugDioInterceptor.resposneCount, 0);
    expect(instabugDioInterceptor.errorCount, 1);
  });

  test('Stress Test', () async {
    for (var i = 0; i < 1000; i++) {
      try {
        await dio.get<dynamic>('/test');
        // ignore: deprecated_member_use
      } on DioError {
        // ignor
      }
    }
    expect(instabugDioInterceptor.requestCount, 1000);
  });
}
