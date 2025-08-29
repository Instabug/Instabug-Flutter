part of '../../main.dart';

class UserStepsPage extends StatefulWidget {
  static const screenName = 'user_steps';

  const UserStepsPage({Key? key}) : super(key: key);

  @override
  _UserStepsPageState createState() => _UserStepsPageState();
}

class _UserStepsPageState extends State<UserStepsPage> {
  double _currentSliderValue = 20.0;

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  String? _sliderStatus;

  bool? isChecked = true;

  int? _selectedValue = 1;

  bool light = true;
  double _scale = 1.0; // Initial scale of the image

  TextEditingController _controller = TextEditingController();

  String _currentValue = '';
  List<String> _items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _currentValue = _controller.text;
      });
    });
  }

  void _handleRadioValueChanged(int? value) {
    setState(() {
      _selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'User Steps',
      children: [
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
                    controller: _controller,
                    // Bind the controller to the TextField
                    decoration: InputDecoration(
                      labelText: "Type something in a text field with key",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    // Bind the controller to the TextField
                    decoration: InputDecoration(
                      labelText: "Private view",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    // Bind the controller to the TextField
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _controller,
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
      ],
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the controller when the widget is destroyed
    super.dispose();
  }
}
