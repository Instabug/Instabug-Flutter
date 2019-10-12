import 'dart:io';

import 'package:instabug_flutter/instabug_custom_http_client.dart';

class InstabugHttpOverrides extends HttpOverrides {
  InstabugHttpOverrides({
    this.current,
    this.findProxyFromEnvironmentFn,
    this.createHttpClientFn,
  });

  final String Function(Uri url, Map<String, String> environment)
  findProxyFromEnvironmentFn;
  final HttpClient Function(SecurityContext context) createHttpClientFn;
  final HttpOverrides current;

  @override
  HttpClient createHttpClient(SecurityContext context) {
    final HttpClient client = createHttpClientFn != null
        ? createHttpClientFn(context)
        : current?.createHttpClient(context) ?? super.createHttpClient(context);

    return InstabugCustomHttpClient(client: client);
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String> environment) {
    return findProxyFromEnvironmentFn != null
        ? findProxyFromEnvironmentFn(url, environment)
        : super.findProxyFromEnvironment(url, environment);
  }
}
