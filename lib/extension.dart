import 'package:flutter/material.dart';

extension date on DateTime {
  String get pickDate =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}";
}

extension time on TimeOfDay {
  String get pickTime =>
      "${(hour % 12).toString().padLeft(2, '0')} : ${minute.toString().padLeft(2, '0')} ";
}
