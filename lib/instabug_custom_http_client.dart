import 'dart:io';

import 'package:instabug_flutter/utils/http_client_logger.dart';
import 'package:meta/meta.dart';

class InstabugCustomHttpClient extends HttpClientLogger implements HttpClient {
  InstabugCustomHttpClient() : client = HttpClient() {
    logger = this;
  }

  @override
  set autoUncompress(bool au) => client.autoUncompress = au;

  @override
  set connectionTimeout(Duration? ct) => client.connectionTimeout = ct;

  @override
  set idleTimeout(Duration it) => client.idleTimeout = it;

  @override
  set maxConnectionsPerHost(int? mcph) => client.maxConnectionsPerHost = mcph;

  @override
  set userAgent(String? ua) => client.userAgent = ua;

  @override
  bool get autoUncompress => client.autoUncompress;

  @override
  Duration? get connectionTimeout => client.connectionTimeout;

  @override
  Duration get idleTimeout => client.idleTimeout;

  @override
  int? get maxConnectionsPerHost => client.maxConnectionsPerHost;

  @override
  String? get userAgent => client.userAgent;

  @visibleForTesting
  HttpClient client;

  @visibleForTesting
  late HttpClientLogger logger;

  @override
  void addCredentials(
          Uri url, String realm, HttpClientCredentials credentials) =>
      client.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm,
          HttpClientCredentials credentials) =>
      client.addProxyCredentials(host, port, realm, credentials);

  @override
  set authenticate(
          Future<bool> Function(Uri url, String scheme, String realm)? f) =>
      client.authenticate = f;

  @override
  set authenticateProxy(
          Future<bool> Function(
                  String host, int port, String scheme, String realm)?
              f) =>
      client.authenticateProxy = f;

  @override
  set badCertificateCallback(
          bool Function(X509Certificate cert, String host, int port)?
              callback) =>
      client.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => client.close(force: force);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      client.delete(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) =>
      client.deleteUrl(url).then(_finish);

  @override
  set findProxy(String Function(Uri url)? f) => client.findProxy = f;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      client.get(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> getUrl(Uri url) => client.getUrl(url).then(_finish);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      client.head(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> headUrl(Uri url) =>
      client.headUrl(url).then(_finish);

  @override
  Future<HttpClientRequest> open(
          String method, String host, int port, String path) =>
      client.open(method, host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      client.openUrl(method, url).then(_finish);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      client.patch(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) =>
      client.patchUrl(url).then(_finish);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      client.post(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> postUrl(Uri url) =>
      client.postUrl(url).then(_finish);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      client.put(host, port, path).then(_finish);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => client.putUrl(url).then(_finish);

  Future<HttpClientRequest> _finish(HttpClientRequest request) async {
    logger.onRequest(request);
    final response = await request.close();
    logger.onResponse(response, request);
    return request;
  }
}
