import 'package:flutter/cupertino.dart';

String toUpperFirst(String str) {
  return str.substring(0,1).toUpperCase() + str.substring(1,str.length).toLowerCase();
}

String extractFromController(TextEditingController ctrl) {
  return ctrl.text.trim();
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}