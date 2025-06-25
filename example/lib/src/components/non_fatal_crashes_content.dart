part of '../../main.dart';

class NonFatalCrashesContent extends StatefulWidget {
  const NonFatalCrashesContent({Key? key}) : super(key: key);

  @override
  State<NonFatalCrashesContent> createState() => _NonFatalCrashesContentState();
}

class _NonFatalCrashesContentState extends State<NonFatalCrashesContent> {
  void throwHandledException(dynamic error) {
    try {
      if (error is! Error) {
        const appName = 'Flutter Test App';
        final errorMessage = error?.toString() ?? 'Unknown Error';
        error = Exception('Handled Error: $errorMessage from $appName');
      }
      throw error;
    } catch (err) {
      if (err is Error) {
        log('throwHandledException: Crash report for ${err.runtimeType} is Sent!',
            name: 'NonFatalCrashesWidget');
      }
    }
  }

  final crashFormKey = GlobalKey<FormState>();

  final crashNameController = TextEditingController();

  final crashfingerPrintController = TextEditingController();

  final crashUserAttributeKeyController = TextEditingController();

  final crashUserAttributeValueController = TextEditingController();

  NonFatalExceptionLevel crashType = NonFatalExceptionLevel.error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugButton(
          text: 'Throw Exception',
          key: const Key('non_fatal_exception'),
          onPressed: () =>
              throwHandledException(Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          key: const Key('non_fatal_state_exception'),
          onPressed: () =>
              throwHandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          key: const Key('non_fatal_argument_exception'),

          onPressed: () =>
              throwHandledException(ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          key: const Key('non_fatal_range_exception'),

          onPressed: () => throwHandledException(
              RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          key: const Key('non_fatal_format_exception'),

          onPressed: () =>
              throwHandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          key: const Key('non_fatal_no_such_method_exception'),

          onPressed: () {
            dynamic obj;
            throwHandledException(obj.methodThatDoesNotExist());
          },
        ),
        const InstabugButton(
          text: 'Throw Handled Native Exception',
          key: Key('non_fatal_native_exception'),

          onPressed:
              InstabugFlutterExampleMethodChannel.sendNativeNonFatalCrash,
        ),
        Form(
          key: crashFormKey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: InstabugTextField(
                    label: "Crash title",
                    key: const Key("non_fatal_crash_title_textfield"),
                    controller: crashNameController,
                    validator: (value) {
                      if (value?.trim().isNotEmpty == true) return null;

                      return 'this field is required';
                    },
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: InstabugTextField(
                    label: "User Attribute  key",
                        key: const Key("non_fatal_user_attribute_key_textfield"),

                        controller: crashUserAttributeKeyController,
                    validator: (value) {
                      if (crashUserAttributeValueController.text.isNotEmpty) {
                        if (value?.trim().isNotEmpty == true) return null;

                        return 'this field is required';
                      }
                      return null;
                    },
                  )),
                  Expanded(
                      child: InstabugTextField(
                    label: "User Attribute  Value",
                        key: const Key("non_fatal_user_attribute_value_textfield"),

                        controller: crashUserAttributeValueController,
                    validator: (value) {
                      if (crashUserAttributeKeyController.text.isNotEmpty) {
                        if (value?.trim().isNotEmpty == true) return null;

                        return 'this field is required';
                      }
                      return null;
                    },
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: InstabugTextField(
                    label: "Fingerprint",
                        key: const Key("non_fatal_user_attribute_fingerprint_textfield"),

                        controller: crashfingerPrintController,
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: DropdownButtonHideUnderline(
                          key: const Key("non_fatal_crash_level_dropdown"),

                          child:
                              DropdownButtonFormField<NonFatalExceptionLevel>(
                            value: crashType,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), isDense: true),
                            padding: EdgeInsets.zero,
                            items: NonFatalExceptionLevel.values
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.toString()),
                                    ))
                                .toList(),
                            onChanged: (NonFatalExceptionLevel? value) {
                              crashType = value!;
                            },
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              InstabugButton(
                text: 'Send Non Fatal Crash',
                onPressed: sendNonFatalCrash,
              )
            ],
          ),
        ),
      ],
    );
  }

  void sendNonFatalCrash() {
    if (crashFormKey.currentState?.validate() == true) {
      Map<String, String>? userAttributes = null;
      if (crashUserAttributeKeyController.text.isNotEmpty) {
        userAttributes = {
          crashUserAttributeKeyController.text:
              crashUserAttributeValueController.text
        };
      }
      CrashReporting.reportHandledCrash(
          new Exception(crashNameController.text), null,
          userAttributes: userAttributes,
          fingerprint: crashfingerPrintController.text,
          level: crashType);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Crash sent")));
      crashNameController.text = '';
      crashfingerPrintController.text = '';
      crashUserAttributeValueController.text = '';
      crashUserAttributeKeyController.text = '';
    }
  }
}
