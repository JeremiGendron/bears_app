import 'package:bears_flutter/components/hints/error_hint.dart';
import 'package:bears_flutter/components/hints/info_hint.dart';
import 'package:bears_flutter/utils/scroll_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scroll_controller.dart';
import '../date_of_birth.dart';
import '../standard_input.dart';
import 'header.dart';
import 'input_row.dart';

class SignupPasswordModel extends SignupStandardInputModel {

  String _strength;
  String get strength => _strength;
  

  @override set value(String input) {
    if (input != value) {
      super.value = input;
      _strength = _calculateStrength(input);
      notifyListeners();
    }
  }

  @override String validate(String input) {
    print(dirty);
    if (dirty && input.length == 0) return "required";
    if (!dirty) return "ok";
    if (input.length > 7) return "ok";
    if (input.length < 8) return "invalid";
    return null;
  }

  @override final String name = 'password';

  @override final String display = 'Password';

  @override final Widget headerStatus = PasswordHeaderStatus();

  @override final TextInputType textInputType = TextInputType.text;

  @override final TextEditingController controller = TextEditingController();

  @override final FocusNode focusNode = FocusNode();

  @override final bool autoFocus = false;

  @override final List<TextInputFormatter> inputFormatters = null;

  @override final int maxLength = 120;

  @override void onFieldSubmitted(BuildContext context) {
    SignupDateOfBirthModel dateOfBirthModel = ScopedModel.of<SignupDateOfBirthModel>(context, rebuildOnChange: false);
    FocusScope.of(context).requestFocus(dateOfBirthModel.focusNode);
  }
  
  @override TextInputAction textInputAction = TextInputAction.next;

  @override final Widget fieldRow = PasswordInputRow();

  @override final Map<String, Widget> hints = {
    "ok": infoHint("Strong passwords include a mix of lower case letters, upper case letters, numbers and special characters."),
    "required": errorHint("The password field is required."),
    "invalid": errorHint("This password doesn't have at least 8 characters.")
  };

  @override final Map<String, bool> validity = {
    "ok": true,
    "required": false,
    "invalid": false,
  };
}

String _calculateStrength(String input) {
  if (input.length < 8) return null;

  final int numberP = _number.hasMatch(input) ? 1 : 0;
  final int upperP = _upper.hasMatch(input) ? 1 : 0;
  final int lowerP = _lower.hasMatch(input) ? 1 : 0;
  final int specialP = _special.hasMatch(input) ? 1 : 0;

  return numberP + upperP + lowerP + specialP < 3 ? 'Weak' : 'Strong';
}

RegExp _number = RegExp(r'[0-9]');
RegExp _upper = RegExp(r'[A-Z]');
RegExp _lower = RegExp(r'[a-z]');
RegExp _special = RegExp(r'\W');