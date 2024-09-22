part of '../../main.dart';

class NetworkContent extends StatefulWidget {
  const NetworkContent({Key? key}) : super(key: key);
  final String defaultRequestUrl =
      'https://jsonplaceholder.typicode.com/posts/1';

  @override
  State<NetworkContent> createState() => _NetworkContentState();
}

class _NetworkContentState extends State<NetworkContent> {
  final endpointUrlController = TextEditingController();

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
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
        Text("W3C Header Section"),
        InstabugButton(
          text: 'Send Request With Custom traceparent header',
          onPressed: () =>
              _sendRequestToUrl(endpointUrlController.text, headers: {
                "traceparent": "Custom traceparent header"
              }),
        ),
        InstabugButton(
          text: 'Send Request  Without Custom traceparent header',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
      ],
    );
  }

  void _sendRequestToUrl(String text, {Map<String, String>? headers}) async {
    try {
      String url = text
          .trim()
          .isEmpty ? widget.defaultRequestUrl : text;
      String proxy = Platform.isAndroid
          ? '192.168.1.107:9090'
          : 'localhost:9090';

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

      final response = await dio.get(url,options: Options(
        headers: headers
      ));

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
}
