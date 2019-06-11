import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupErrorModel extends Model {
  bool _fatal = false;
  bool get fatal => _fatal;
  set fatal(bool value) {
    if (value != _fatal) {
      _fatal = value;
      notifyListeners();
    }
  }

  String _error;
  String get error => _error;
  set error(String value) {
    if (value != _error) {
      _error = value;
      errors[value] = true;
      notifyListeners();
    }
  }

  Map<String, bool> errors = {
    "email": false,
    "dob": false,
    "token": false
  };

  void clearErrors() {
    errors.keys.forEach((String key) => errors[key] = false);
  }

  static SignupErrorModel of(BuildContext context) =>
      ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: true);

}