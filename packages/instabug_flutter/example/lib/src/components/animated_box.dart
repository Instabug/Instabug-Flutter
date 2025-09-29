part of '../../main.dart';

class AnimatedBox extends StatefulWidget {
  const AnimatedBox({Key? key}) : super(key: key);

  @override
  _AnimatedBoxState createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(minutes: 1, seconds: 40),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation value
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _stopAnimation() {
    _controller.stop();
  }

  void _resetAnimation() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RotationTransition(
          turns: _animation,
          child: const FlutterLogo(size: 100),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _startAnimation(),
              child: const Text('Start'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _stopAnimation(),
              child: const Text('Stop'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _resetAnimation(),
              child: const Text('reset'),
            ),
          ],
        ),
      ],
    );
  }
}
