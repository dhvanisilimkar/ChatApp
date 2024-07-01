import 'package:flutter/widgets.dart';

class DateLabelController extends ChangeNotifier {
  bool dateLabelVisibility = false;
  String dateLabelText = "";

  setVisibilityTrue() {
    dateLabelVisibility = true;
    notifyListeners();
  }

  setVisibilityFalse() {
    dateLabelVisibility = false;
    notifyListeners();
  }

  setText({required String text}) {
    dateLabelText = text;
    if (dateLabelVisibility) {
      notifyListeners();
    }
  }

  refresh() {
    notifyListeners();
  }
}
