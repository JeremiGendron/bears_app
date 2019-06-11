import 'package:bears_flutter/components/hints/error_hint.dart';
import 'package:bears_flutter/components/hints/info_hint.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:bears_flutter/utils/scroll_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scroll_controller.dart';
import 'password/model.dart';
import 'package:http/http.dart' as http;

//dirty && length == 0 ? hints["required"](name) :
//           dirty && !valid ? hints["invalid"](name) :
//           errors[name]?? false ? hints["other"](name) :
//           dirty && valid ? hints["informative"](name) :
//           dirty && focusNode.hasFocus ? hints["informative"](name) :
//           focusNode.hasFocus ? hints["informative"](name) :
//           Container();

class SignupUsernameModel extends SignupStandardInputModel {
  @override Future<String> validate(String input) async {
    if (dirty && input.length == 0) return "required";
    if (!dirty) return "ok";
    if (!usernameRegExp.hasMatch(input) && dirty) return "regExpFail";

    http.Response httpResponse = await http.post("$baseSignupUrl/check-username",
      headers: {
        "Content-Type": "text/plain"
      },
      body: input
    );

    switch (httpResponse.statusCode) {
      case 200:
        return "ok";
      case 400:
        return "regExpFail";
      case 409:
        return "in-use";
      case 500:
        return "unexpected";
      case 502:
        return "unexpected";
      default:
        return "unexpected";
    }
  } 

  @override final String name = 'username';

  @override final String display = 'Username';

  @override final TextInputType textInputType = TextInputType.text;

  @override final TextEditingController controller = TextEditingController();

  @override final FocusNode focusNode = FocusNode();

  @override final bool autoFocus = false;

  @override final List<TextInputFormatter> inputFormatters = null;

  @override final int maxLength = 25;

  @override void onFieldSubmitted(BuildContext context) {
    SignupPasswordModel passwordModel = ScopedModel.of<SignupPasswordModel>(context, rebuildOnChange: false);
    FocusScope.of(context).requestFocus(passwordModel.focusNode);
  }
  
  @override TextInputAction textInputAction = TextInputAction.next;

  @override Map<String, Widget> hints = {
    "ok": infoHint("This is how others see you on Site. You can always change this later."),
    "required": errorHint("The username field is required."),
    "regExpFail": errorHint("The username must be between 3 and 25 letters, numbers or underscores."),
    "in-use": errorHint("The username is already in use."),
    "unexpected": errorHint("An unexpected error happened on our end.")
  };

  @override Map<String, bool> validity = {
    "ok": true,
    "required": false,
    "regExpFail": false,
    "in-use": false,
    "unexpected": false
  };
}

final RegExp usernameRegExp = RegExp(r'^[a-z0-9_]{3,25}$');



//class SignupUsernameModel extends Model {
//  bool _valid;
//  bool get valid => _valid;
//  set valid(bool value) {
//    if (value != _valid) {
//      _valid = value;
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
//  static SignupUsernameModel of(BuildContext context) =>
//    ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: true);
//
//  static bool validate(String value) {
//    return usernameRegExp.hasMatch(value);
//  }
//
//  static SignupUsernameModel to(BuildContext context) =>
//    ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: false);
//
//}
//
//