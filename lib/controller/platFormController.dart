import 'package:flutter/material.dart';

class PlatFormController extends ChangeNotifier {
  bool isIos = false;
  bool isUpdate = false;

  void ChangePlatForm() {
    isIos = !isIos;
    print('${isIos}');
    notifyListeners();
  }

  void ChangeUpdate() {
    isUpdate = !isUpdate;
    notifyListeners();
  }
}
