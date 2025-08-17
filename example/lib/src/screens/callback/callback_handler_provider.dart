import 'package:flutter/foundation.dart';

class KeyValuePair {
  final String key;
  final String value;

  KeyValuePair({required this.key, required this.value});
}

class Item {
  final String id;
  final List<KeyValuePair> fields;

  Item({required this.id, required this.fields});
}

class CallbackHandlersProvider extends ChangeNotifier {
  final Map<String, List<Item>> _callbackHandlers = {};

  Map<String, List<Item>> get callbackHandlers => _callbackHandlers;

  void clearList(String title) {
    _callbackHandlers[title] = [];
    notifyListeners();
  }

  void addItem(String title, Item item) {
    final existingList = _callbackHandlers[title] ?? [];
    _callbackHandlers[title] = [...existingList, item];
    notifyListeners();
  }
}
