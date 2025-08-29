# Instabug Dio Interceptor

[![CircleCI](https://circleci.com/gh/Instabug/Instabug-Dio-Interceptor.svg?style=svg)](https://circleci.com/gh/Instabug/Instabug-Dio-Interceptor)
[![pub package](https://img.shields.io/pub/v/instabug_dio_interceptor.svg)](https://pub.dev/packages/instabug_dio_interceptor)

This package is an add on to [Instabug-Flutter](https://github.com/Instabug/Instabug-Flutter).

It intercepts any requests performed with `Dio` Package and sends them to the report that will be sent to the dashboard.  

## Integration

To enable network logging, simply add the  `InstabugDioInterceptor` to the dio object interceptors as follows:

```dart
var dio = new Dio();
dio.interceptors.add(InstabugDioInterceptor());
```
