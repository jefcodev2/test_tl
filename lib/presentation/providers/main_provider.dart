import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProviderGeneral with ChangeNotifier {
  int _activeStep = 0;
  int get activeStep => _activeStep;
  set activeStep(int value) {
    _activeStep = value;
    notifyListeners();
  }
}
