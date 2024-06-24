import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:platform_convertion/modal/userContactModal.dart';

class FunctionController extends ChangeNotifier {
  File? userImage;
  String? userNumber;
  String? userName;
  String? userMsg;
  DateTime? userDate;
  TimeOfDay? userTime;
  File? image;
  String? name;
  String? bio;
  List<UserContactModal> allContact = [];

  Future<void> pickDate({required context}) async {
    userDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 7),
      ),
    );
    notifyListeners();
  }

  Future<void> pickTime({required context}) async {
    userTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    notifyListeners();
  }

  void addContact(UserContactModal User) {
    if (allContact.contains(User)) {
    } else {
      allContact.add(User);
      userImage = null;
      userNumber = null;
      userName = null;
      userMsg = null;
    }

    Logger().i(allContact);

    notifyListeners();
  }
}
