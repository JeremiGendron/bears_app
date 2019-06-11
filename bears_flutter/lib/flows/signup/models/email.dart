import 'package:bears_flutter/components/hints/error_hint.dart';
import 'package:bears_flutter/components/hints/info_hint.dart';
import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:bears_flutter/flows/signup/scroll_controller.dart';
import 'package:bears_flutter/utils/scroll_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'username.dart';

class SignupEmailModel extends SignupStandardInputModel {

  @override String validate(String input) {
    if (dirty && input.length == 0) return "required";
    if (!dirty) return "ok";
    if (!emailRegExp.hasMatch(input) && dirty) return "regExpFail";
    if (emailRegExp.hasMatch(input)) return "ok";
    return null;
  }

  @override final String name = 'email';

  @override final TextInputType textInputType = TextInputType.emailAddress;

  @override final TextEditingController controller = TextEditingController();

  @override final FocusNode focusNode = FocusNode();

  @override final bool autoFocus = true;

  @override final String display = 'Email';

  @override final int maxLength = 100;

  @override final List<TextInputFormatter> inputFormatters = null;

  @override void onFieldSubmitted(BuildContext context) {
    SignupUsernameModel usernameModel = ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: false);
    FocusScope.of(context).requestFocus(usernameModel.focusNode);
  }
  
  @override TextInputAction textInputAction = TextInputAction.next;

  @override Map<String, Widget> hints = {
    "ok": infoHint("You'll need to confirm that you own this email account."),
    "required": errorHint("The email field is required."),
    "regExpFail": errorHint("The email is invalid."), 
  };
  @override Map<String, bool> validity = {
    "ok": true,
    "required": false,
    "regExpFail": false,
  };
}

final RegExp emailRegExp = RegExp(r'^(\D)+(\w)*((\.(\w)+)?)+@(\D)+(\w)*((\.(\D)+(\w)*)+)?(\.)[a-z]{2,}$');

//class SignupEmailModel extends Model {
//  bool _valid = false;
//  bool get valid => _valid;
//  set valid(bool value) {
//    if (value != _valid) {
//      _valid = value;
//      notifyListeners();
//    }
//  }
//
//  bool _dirty = false;
//  bool get dirty => _dirty;
//  set dirty(bool value) {
//    if (value != _dirty) {
//      _dirty = value;
//      notifyListeners();
//    }
//  }
//
//  bool _loading = false;
//  bool get loading => _loading;
//  set loading(bool value) {
//    if (!_dirty) return;
//    if (value != _loading) {
//      _loading = value;
//      notifyListeners();
//    }
//  }
//
//  String _value = '';
//  String get value => _value;
//  set value(String text) {
//    if (text != _value) {
//      _value = text;
//      notifyListeners();
//    }
//  }
//
//  static SignupEmailModel of(BuildContext context) =>
//    ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: true);
//
//  static SignupEmailModel to(BuildContext context) =>
//    ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: false);
//
//  static bool validate(String value) => emailRegExp.hasMatch(value);
//}

