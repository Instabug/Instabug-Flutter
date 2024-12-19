
import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_private_views/instabug_private_view.dart';
import 'package:video_player/video_player.dart';

class PrivateViewPage extends StatefulWidget {
  const PrivateViewPage({Key? key}) : super(key: key);

  @override
  _PrivateViewPageState createState() => _PrivateViewPageState();
}

class _PrivateViewPageState extends State<PrivateViewPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )
      ..initialize().then((_) {
        setState(() {});
      });

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..repeat(); // Continuously rotates the widget
    _animation = Tween<double>(begin: 0, end: 100).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Private Views page")),
        body: SingleChildScrollView(
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
                AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return                 InstabugPrivateView(
                        child: Transform.translate(
                          offset: Offset(_animation.value, 0), // Move along the x-axis
                          // 20 pixels right, 10 pixels down
                          child: const Icon(Icons.star, size: 50),
                        ),
                      );
                    }
                ),
                const SizedBox(height: 16),

                InstabugPrivateView(
                  child: ElevatedButton(
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Text('Hello, you clicked on a private button'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                const SizedBox(height: 16),
                InstabugPrivateView(
                  child: RotationTransition(
                    turns: _animationController,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: <Widget>[
                    InstabugPrivateView(
                      child: const Text(
                        'Private TextView in column',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'TextView in column',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                            child: const Text(
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
      ),
    );
  }
}
