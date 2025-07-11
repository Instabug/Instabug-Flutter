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
        InstabugClipboardInput(
          label: 'Endpoint Url',
          controller: endpointUrlController,
        ),
        InstabugButton(
          text: 'Send Request To Url',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
        const Text("W3C Header Section"),
        InstabugButton(
          text: 'Send Request With Custom traceparent header',
          onPressed: () =>
              _sendRequestToUrl(endpointUrlController.text,
                  headers: {"traceparent": "Custom traceparent header"}),
        ),
        InstabugButton(
          text: 'Send Request  Without Custom traceparent header',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
        InstabugButton(
          text: 'obfuscateLog',
          onPressed: () {
            NetworkLogger.obfuscateLog((networkData) async {
              return networkData.copyWith(url: 'fake url');
            });
          },
        ),

        InstabugButton(
          text: 'omitLog',
          onPressed: () {
            NetworkLogger.omitLog((networkData) async {
              return networkData.url.contains('google.com');
            });
          },
        ),

        InstabugButton(
          text: 'obfuscateLogWithException',
          onPressed: () {
            NetworkLogger.obfuscateLog((networkData) async {
              throw Exception("obfuscateLogWithException");

              return networkData.copyWith(url: 'fake url');
            });
          },
        ),

        InstabugButton(
          text: 'omitLogWithException',
          onPressed: () {
            NetworkLogger.omitLog((networkData) async {
              throw Exception("OmitLog with exception");

              return networkData.url.contains('google.com');
            });
          },
        ),
      ],
    );
  }

  void _sendRequestToUrl(String text, {Map<String, String>? headers}) async {
    try {
      String url = text
          .trim()
          .isEmpty ? widget.defaultRequestUrl : text;
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
