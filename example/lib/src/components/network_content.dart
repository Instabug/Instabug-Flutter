part of '../../main.dart';

class NetworkContent extends StatefulWidget {
  const NetworkContent({Key? key}) : super(key: key);
  final String defaultRequestUrl =
      'https://jsonplaceholder.typicode.com/posts/1';

  @override
  State<NetworkContent> createState() => _NetworkContentState();
}

class _NetworkContentState extends State<NetworkContent> {
  final http2 = InstabugHttpClient();

  final endpointUrlController = TextEditingController();
  String proxy = Platform.isAndroid ? '192.168.1.107:8888' : 'localhost:8888';

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugClipboardInput(
          label: 'Endpoint Url',
          controller: endpointUrlController,
        ),
        InstabugButton(
          text: 'Send Request To Url',
          onPressed: () => _sendRequestToUrlDio(endpointUrlController.text),
        ),
        Text("W3C Header Section2"),
        InstabugButton(
          text: 'Send Request With Custom traceparent header dio',
          onPressed: () => _sendRequestToUrlDio(endpointUrlController.text,
              headers: {"traceparent": "Custom traceparent header "}),
        ),
        InstabugButton(
          text: 'Send Request  Without Custom traceparent header dio ',
          onPressed: () => _sendRequestToUrlDio(endpointUrlController.text),
        ),
        InstabugButton(
          text: 'Send Request With Custom traceparent header http',
          onPressed: () => _sendRequestToUrlHttpClient(
              endpointUrlController.text,
              headers: {"traceparent": "Custom traceparent header "}),
        ),
        InstabugButton(
          text: 'Send Request  Without Custom traceparent header http ',
          onPressed: () =>
              _sendRequestToUrlHttpClient(endpointUrlController.text),
        ),
      ],
    );
  }

  void _sendRequestToUrlDio(String text, {Map<String, String>? headers}) async {
    try {
      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;

// Create a new Dio instance.
      Dio dio = Dio();

// Tap into the onHttpClientCreate callback
// to configure the proxy just as we did earlier.
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // Hook into the findProxy callback to set the client's proxy.
        client.findProxy = (url) {
          return 'PROXY $proxy';
        };

        // This is a workaround to allow Proxyman to receive
        // SSL payloads when your app is running on Android.
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => Platform.isAndroid;
      };

      dio.interceptors.add(InstabugDioInterceptor());

      final response = await dio.get(url, options: Options(headers: headers));

      // Handle the response here
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.data);
        log(jsonEncode(jsonData));
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending request: $e');
    }
  }

  void _sendRequestToUrlHttpClient(String text,
      {Map<String, String>? headers}) async {
    try {
     final httpProxy= await  HttpProxy.createHttpProxy();
     httpProxy.host = proxy.split(":")[0];
     httpProxy.port = proxy.split(":")[1];
     HttpOverrides.global = httpProxy;

      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;
      final response = await http2.get(Uri.parse(url),headers: headers);

      // Handle the response here
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        log(jsonEncode(jsonData));
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending request: $e');
    }
  }
}
