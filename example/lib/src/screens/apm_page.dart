part of '../../main.dart';

class ApmPage extends StatefulWidget {
  static const screenName = 'apm';

  const ApmPage({Key? key}) : super(key: key);

  @override
  State<ApmPage> createState() => _ApmPageState();
}

class _ApmPageState extends State<ApmPage> {
  late WebViewController _webViewController;

  void _navigateToScreenLoading() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreenLoadingPage(),
        settings: const RouteSettings(
          name: ScreenLoadingPage.screenName,
        ),
      ),
    );
  }

  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('APM'),
            floating: true,
            snap: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverInstabugPrivateView(
              sliver: const SliverAppBar(
                backgroundColor: Colors.red,
                title: Text('APM 2'),
                floating: true,
                snap: true,
                expandedHeight: 100.0,
              ),
            ),
          ),
          const SliverAppBar(
            title: Text('APM 3'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: WebViewWidget(controller: _webViewController),
                ),
                InstabugPrivateView(
                  child: const SectionTitle('Network'),
                ),
                const NetworkContent(),
                const SectionTitle('Traces'),
                const TracesContent(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InstabugPrivateView(
                      child: const SectionTitle('Flows'),
                    ),
                    Text("I'm not private!"),
                    InstabugPrivateView(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                    ),
                    InstabugPrivateView(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.green,
                      ),
                    ),
                    InstabugPrivateView(
                      child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const FlowsContent(),
                const SectionTitle('Screen Loading'),
                SizedBox.fromSize(
                  size: const Size.fromHeight(12),
                ),
                InstabugButton(
                  text: 'Screen Loading',
                  onPressed: _navigateToScreenLoading,
                ),
                SizedBox.fromSize(
                  size: const Size.fromHeight(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
