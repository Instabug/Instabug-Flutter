part of '../../main.dart';

class NetworkContent extends StatefulWidget {
  const NetworkContent({Key? key}) : super(key: key);
  final String defaultRequestUrl =
      'https://jsonplaceholder.typicode.com/posts/1';

  @override
  State<NetworkContent> createState() => _NetworkContentState();
}

class _NetworkContentState extends State<NetworkContent> {
  final dio = Dio();

  @override
  void initState() {
    dio.interceptors.add(InstabugDioInterceptor());
    super.initState();
  }

  final endpointUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugPrivateView(
          child: InstabugClipboardInput(
            label: 'Endpoint Url',
            controller: endpointUrlController,
          ),
        ),
        InstabugButton(
          text: 'Send Request To Url',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
        Text("W3C Header Section"),
        InstabugButton(
          text: 'Send Request With Custom traceparent header',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text,
              headers: {"traceparent": "Custom traceparent header"}),
        ),
        InstabugButton(
          text: 'Send Request  Without Custom traceparent header',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
        InstabugButton(
          text: 'Send Request  WithBody',
          onPressed: () =>
              _sendRequestToUrlWithBody(endpointUrlController.text),
        ),
      ],
    );
  }

  void _sendRequestToUrl(String text, {Map<String, String>? headers}) async {
    try {
      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;
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

  void _sendRequestToUrlWithBody(String text,
      {Map<String, String>? headers}) async {
    try {
      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;

      final response = await dio.post(url,
          data: <String, dynamic>{"Password": "1222", "name": "ahmed"},
          options: Options(headers: headers));

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
