import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

typedef hint = Expanded Function(String name);

abstract class SignupStandardInputModel extends Model {

  bool _valid = false;
  bool get valid => _valid;
  set valid(bool value) {
    if (value != _valid) {
      _valid = value;
      notifyListeners();
    }
  }

  bool _dirty = false;
  bool get dirty => _dirty;
  set dirty(bool value) {
    if (value != _dirty) {
      _dirty = value;
      notifyListeners();
    }
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    if (!_dirty) return;
    if (value != _loading) {
      _loading = value;
      notifyListeners();
    }
  }

  String _value = '';
  String get value => _value;
  set value(String text) {
    if (text != _value) {
      _value = text;
      notifyListeners();
    }
  }

  void onChange(String input) async {
      loading = true;

      if (input.length > 0) dirty = true;

      var validationResult = await validate(input);
      if (validationResult == null) return;

      hintWidget = hints[validationResult];
      valid = validity[validationResult];

      value = input;
      loading = false;
  }

  // These 3 widgets have a default
  Widget fieldRow;
  Widget headerStatus;
  Widget hintWidget;

  @required FutureOr<String> validate(String input);
  @required String name;
  @required TextInputType textInputType;
  @required TextEditingController controller;
  @required FocusNode focusNode;
  @required bool autoFocus;
  @required String display;
  @required List<TextInputFormatter> inputFormatters;
  @required int maxLength;
  @required void onFieldSubmitted(BuildContext context);
  @required TextInputAction textInputAction;
  @required Map<String, Widget> hints;
  @required Map<String, bool> validity;

  SignupStandardInputModel() {
    //focusNode.addListener(() => notifyListeners());
  }
}
