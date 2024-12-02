import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  TextEditingController _controller = TextEditingController();

  String _currentValue = '';

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
          Image.network("https://t3.ftcdn.net/jpg/00/50/07/64/360_F_50076454_TCvZEw37VyB5ZhcwEjkJHddtuV1cFmKY.jpg",height:100),
        ]),
            
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
            ]
           
          ),


          SectionTitle('TextInput'),
          Column(

            children: [
              Padding(
                padding: EdgeInsets.all(16.0), // Set the padding value
                child: Column(
                  children: [
                    TextField(
                      controller: _controller, // Bind the controller to the TextField
                      decoration: InputDecoration(
                        labelText: "Type something",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _controller, // Bind the controller to the TextField
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    TextFormField(
                       obscureText: true,
                      controller: _controller, // Bind the controller to the TextField
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
                        return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      },
                    ),

                  ],
                ),
              ),
            ],

          ),
        
        SectionTitle('Sheets / Alerts'),
        Column(
          children: [
                    SimpleDialog(
        title: const Text('Select assignment'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () { print("aaaaa"); },
            child: const Text('Treasury department'),
          ),
          SimpleDialogOption(
            onPressed: () { print( "bbbbb"); },
            child: const Text('State department'),
          ),
        ],
      ),
                      AlertDialog(
         title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          )
        ),
                      ),
                    ],
                  ),

      
      ]
     
    );
  }
 @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is destroyed
    super.dispose();
  }

}

