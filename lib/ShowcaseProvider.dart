import 'package:flutter/foundation.dart';

class ShowcaseProvider extends ChangeNotifier {
  bool _isShowcaseEnabled = false;
  bool get isShowcaseEnabled => _isShowcaseEnabled;

  void toggleShowcase() {
    _isShowcaseEnabled = !_isShowcaseEnabled;
    notifyListeners();
  }
}