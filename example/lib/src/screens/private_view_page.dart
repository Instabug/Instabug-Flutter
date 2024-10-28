part of '../../main.dart';

class PrivateViewPage extends StatefulWidget {
  const PrivateViewPage({Key? key}) : super(key: key);

  @override
  _PrivateViewPageState createState() => _PrivateViewPageState();
}

class _PrivateViewPageState extends State<PrivateViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Page(title: 'Private views', children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              InstabugPrivateView(
                child: const Text(
                  'Private TextView',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              InstabugPrivateView(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to a private web view
                  },
                  child: const Text('I am a private button'),
                ),
              ),
              const SizedBox(height: 16),
              InstabugPrivateView(
                child: Image.asset(
                  'assets/img.png',
                  // Add this image to your assets folder
                  height: 100,
                ),
              ),
              const SizedBox(height: 33),
              InstabugPrivateView(
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              InstabugPrivateView(
                child: Container(
                  height: 300,
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: CustomScrollView(
                  slivers: [
                    InstabugSliverPrivateView(
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          color: Colors.red,
                          child: Text(
                            "Private Sliver Widget",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
