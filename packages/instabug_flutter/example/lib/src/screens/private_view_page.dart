import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    return Scaffold(
        appBar: AppBar(title: const Text("Private Views page")),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
          ),
        ));
  }
}
