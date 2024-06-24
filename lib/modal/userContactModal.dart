import 'dart:io';

import 'package:flutter/material.dart';

class UserContactModal {
  File? userImage;
  String? userNumber;
  String? userName;
  String? userMsg;
  DateTime? userDate;
  TimeOfDay? userTime;

  UserContactModal({
    required this.userImage,
    required this.userNumber,
    required this.userName,
    required this.userMsg,
    required this.userDate,
    required this.userTime,
  });
}
