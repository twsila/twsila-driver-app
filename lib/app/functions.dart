import 'package:flutter/cupertino.dart';

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
bool isCurrentRoute(BuildContext context, String routeName) {
  return ModalRoute.of(context)?.settings.name == routeName;
}