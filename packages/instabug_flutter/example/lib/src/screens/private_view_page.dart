import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/src/widget/section_title.dart';
import 'package:video_player/video_player.dart';

class PrivateViewPage extends StatefulWidget {
  static const screenName = 'private';

  const PrivateViewPage({Key? key}) : super(key: key);

  @override
  _PrivateViewPageState createState() => _PrivateViewPageState();
}

class _PrivateViewPageState extends State<PrivateViewPage> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 20.0;

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  String? _sliderStatus;

  bool? isChecked = true;

  int? _selectedValue = 1;

  bool light = true;
  double _scale = 1.0; // Initial scale of the image

  TextEditingController _controller2 = TextEditingController();

  String _currentValue = '';
  List<String> _items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )..initialize().then((_) {
        setState(() {});
      });
    _controller2.addListener(() {
      setState(() {
        _currentValue = _controller2.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRadioValueChanged(int? value) {
    setState(() {
      _selectedValue = value;
    });
  }

  int count = 200;
  final list = List.generate(
      20,
      (_) => InstabugPrivateView(
            child: Container(
              margin: const EdgeInsets.all(2),
              width: 4,
              height: 4,
              color: Colors.red,
            ),
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Private Views page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const InstabugPrivateView(
                child: Text(
                  'Private TextView',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                children: list,
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
              const BackButton(),
              const SectionTitle('TextInput'),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Set the padding value
                    child: Column(
                      children: [
                        TextField(
                          key: const Key('text_field'),
                          controller: _controller2,
                          // Bind the controller to the TextField
                          decoration: const InputDecoration(
                            labelText:
                                "Type something in a text field with key",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        InstabugPrivateView(
                          child: TextField(
                            controller: _controller2,
                            // Bind the controller to the TextField
                            decoration: const InputDecoration(
                              labelText: "Private view",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        InstabugPrivateView(
                          child: TextField(
                            controller: _controller2,
                            // Bind the controller to the TextField
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _controller2,
                          // Bind the controller to the TextField
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'What do people call you?',
                            labelText: 'Name *',
                          ),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            return (value != null && value.contains('@'))
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InstabugPrivateView(
                child: Image.asset(
                  'assets/img.png',
                  // Add this image to your assets folder
                  height: 100,
                ),
              ),
              const SizedBox(height: 33),
              const InstabugPrivateView(
                child: TextField(
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
              const Column(
                children: <Widget>[
                  InstabugPrivateView(
                    child: Text(
                      'Private TextView in column',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'TextView in column',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 300,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const Center(child: CircularProgressIndicator()),
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
    );
  }
}
