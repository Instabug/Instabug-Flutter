import 'dart:io';

import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/models/network_data.dart';

class InstabugIoHttpClient implements HttpClient {

  InstabugIoHttpClient({HttpClient client}) : client = client ?? HttpClient();

  final HttpClient client;

  @override
  set autoUncompress(bool au) => client.autoUncompress = au;

  @override
  set connectionTimeout(Duration ct) => client.connectionTimeout = ct;

  @override
  set idleTimeout(Duration it) => client.idleTimeout = it;

  @override
  set maxConnectionsPerHost(int mcph) => client.maxConnectionsPerHost = mcph;

  @override
  set userAgent (String ua) => client.userAgent = ua;

  @override
  bool get autoUncompress => client.autoUncompress;

  @override
  Duration get connectionTimeout => client.connectionTimeout;

  @override
  Duration get idleTimeout => client.idleTimeout;

  @override
  int get maxConnectionsPerHost => client.maxConnectionsPerHost;

  @override
  String get userAgent => client.userAgent;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {
    client.addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {
    client.addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String realm) f) {
    client.authenticate = f;
  }

  @override
  set authenticateProxy(
      Future<bool> Function(String host, int port, String scheme, String realm)
      f) {
    client.authenticateProxy = f;
  }

  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port) callback) {
    client.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    client.close(force: force);
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    return client.delete(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    return client.deleteUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  set findProxy(String Function(Uri url) f) {
    client.findProxy = f;
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    return client.get(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return client.getUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    return client.head(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    return client.headUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    return client.open(method, host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return client.openUrl(method, url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    return client.patch(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    return client.patchUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    return client.post(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    return client.postUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    return client.put(host, port, path).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    return client.putUrl(url).then((HttpClientRequest request) async {
      logNetworkIoRequest(request);
      return request;
    });
  }

  static Future<void> logNetworkIoRequest(HttpClientRequest request, {
    DateTime startTime,
    dynamic requestBody,
    dynamic responseBody,
  }) async {
    final NetworkData networkData = NetworkData();
    networkData.method = request.method;
    networkData.url = request.uri.toString();
    request.headers.forEach((String header, dynamic value) {
      networkData.requestHeaders[header] = value[0];
    });
    networkData.requestBody = requestBody ?? networkData.requestBody;

    networkData.startTime = startTime ?? DateTime.now();
    final HttpClientResponse response = await request.done;
    final DateTime endTime = DateTime.now();

    networkData.status = response.statusCode;
    networkData.duration = endTime.difference(networkData.startTime).inMilliseconds;
    if (response.headers.contentType != null) {
      networkData.contentType = response.headers.contentType.value;
    }

    response.headers.forEach((String header, dynamic value) {
      networkData.responseHeaders[header] = value[0];
    });

    networkData.responseBody = responseBody ?? networkData.responseBody;

    NetworkLogger.networkLog(networkData);
  }
}

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

    return InstabugIoHttpClient(client: client);
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String> environment) {
    return findProxyFromEnvironmentFn != null
        ? findProxyFromEnvironmentFn(url, environment)
        : super.findProxyFromEnvironment(url, environment);
  }
}
