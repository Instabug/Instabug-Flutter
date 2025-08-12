part of '../../main.dart';

class NetworkContent extends StatefulWidget {
  const NetworkContent({Key? key}) : super(key: key);
  final String defaultRequestUrl =
      'https://jsonplaceholder.typicode.com/posts/1';

  @override
  State<NetworkContent> createState() => _NetworkContentState();
}

class _NetworkContentState extends State<NetworkContent> {
  final http = InstabugHttpClient();

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
      ],
    );
  }

  void _sendRequestToUrl(String text, {Map<String, String>? headers}) async {
    try {
      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;
      final response = await http.get(Uri.parse(url), headers: headers);

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
