import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isUser = false;

  bool get isUser => _isUser;

  void setIsUser(bool value) {
    _isUser = value;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });


  }

}