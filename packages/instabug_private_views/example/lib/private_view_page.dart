import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_private_views/instabug_private_view.dart';
import 'package:instabug_private_views_example/widget/instabug_button.dart';
import 'package:instabug_private_views_example/widget/section_title.dart';
import 'package:video_player/video_player.dart';

class PrivateViewPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [InstabugNavigatorObserver()],
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
                BackButton(),
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    return false;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        100,
                            (_) => InkWell(
                          onTap: () {},
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.red,
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SectionTitle('Sliders'),
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 5,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                RangeSlider(
                  values: _currentRangeValues,
                  max: 100,
                  divisions: 5,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                ),
                SectionTitle('Images'),
                Row(
                  children: [
                    Image.asset(
                      'assets/img.png',
                      height: 100,
                    ),
                    Image.network(
                      "https://t3.ftcdn.net/jpg/00/50/07/64/360_F_50076454_TCvZEw37VyB5ZhcwEjkJHddtuV1cFmKY.jpg",
                      height: 100,
                    ),
                  ],
                ),
                InstabugButton(text: "I'm a button"),
                ElevatedButton(onPressed: () {}, child: Text("data")),
                SectionTitle('Toggles'),
                Row(
                  children: [
                    Checkbox(
                      tristate: true,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                    Radio<int>(
                      value: 0,
                      groupValue: _selectedValue,
                      onChanged: _handleRadioValueChanged,
                    ),
                    Switch(
                      value: light,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          light = value;
                        });
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onScaleUpdate: (details) {
                    setState(() {
                      _scale = details.scale;
                      _scale = _scale.clamp(1.0,
                          3.0); // Limit zoom between 1x and 3x// Update scale based on pinch gesture
                    });
                  },
                  onScaleEnd: (details) {
                    // You can add logic to reset or clamp the scale if needed
                    if (_scale < 1.0) {
                      _scale = 1.0; // Prevent shrinking below original size
                    }
                  },
                  child: Transform.scale(
                    scale: _scale, // Apply the scale transformation
                    child: Image.asset(
                      "assets/img.png",
                      height: 300,
                    ),
                  ),
                ),
                SectionTitle('TextInput'),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0), // Set the padding value
                      child: Column(
                        children: [
                          TextField(
                            key: Key('text_field'),
                            controller: _controller2,
                            // Bind the controller to the TextField
                            decoration: InputDecoration(
                              labelText: "Type something in a text field with key",
                              border: OutlineInputBorder(),
                            ),
                          ),
          InstabugPrivateView(
                            child: TextField(
                              controller: _controller2,
                              // Bind the controller to the TextField
                              decoration: InputDecoration(
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
                              decoration: InputDecoration(
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
                    ListView.builder(
                      itemCount: _items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(_items[index]),
                          // Unique key for each item
                          onDismissed: (direction) {
                            // Remove the item from the list
                            setState(() {
                              _items.removeAt(index);
                            });

                            // Show a snackbar or other UI feedback on dismissal
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Item dismissed')),
                            );
                          },
                          background: Container(color: Colors.red),
                          // Background color when swiped
                          direction: DismissDirection.endToStart,
                          // Swipe direction (left to right)
                          child: ListTile(
                            title: Text(_items[index]),
                          ),
                        );
                      },
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
