import 'package:flutter/material.dart';
import 'package:sign_in_screen/core/enums/enum.dart';

class BaseViewmodel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
