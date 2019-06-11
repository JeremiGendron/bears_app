import 'dart:convert';

import 'package:bears_flutter/components/spacing/spacing.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/flows/signup/confirm/confirm.dart';
import 'package:bears_flutter/flows/signup/models/date_of_birth.dart';
import 'package:bears_flutter/flows/signup/models/email.dart';
import 'package:bears_flutter/flows/signup/models/error.dart';
import 'package:bears_flutter/flows/signup/models/password/model.dart';
import 'package:bears_flutter/flows/signup/models/username.dart';
import 'package:bears_flutter/flows/signup/scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final String signupUrl = '';
final String captchaUrl = 'https://jeremigendron.com/captcha.htm';

class SignupButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool fatal = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: true).fatal;
    final bool emailValid = ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: true).valid;
    final bool usernameValid = ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: true).valid;
    final bool passwordValid = ScopedModel.of<SignupPasswordModel>(context, rebuildOnChange: true).valid;
    final bool dateOfBirthValid = ScopedModel.of<SignupDateOfBirthModel>(context, rebuildOnChange: true).valid;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        topSpacer(15),
        fatal || !emailValid || !usernameValid || !passwordValid || !dateOfBirthValid?
          DisabledSignupButton():
          EnabledSignupButton()
      ],
    );

  }
}

class DisabledSignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 11, bottom: 31),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.fromBorderSide(BorderSide(
          color: Colors.grey[500],
          width: 1,
        )),
        borderRadius: BorderRadius.all(Radius.circular(3))

      ),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        onPressed: null,
        disabledTextColor: Colors.grey,
        disabledColor: Colors.grey[200],
        child: Text('Sign Up', style: TextStyle(color: Colors.grey[500],),),
      ),
    );
  }
}

class EnabledSignupButton extends StatefulWidget {
  final FlutterWebviewPlugin plugin = FlutterWebviewPlugin();

  @override
  _EnabledSignupButtonState createState() => _EnabledSignupButtonState();
}

class _EnabledSignupButtonState extends State<EnabledSignupButton> {
  
  String token;

  @override
  void initState() {
    Stream<String> onUrlChanged = widget.plugin.onUrlChanged;
    onUrlChanged.listen((String _url) {
      print(_url);
      if (_url == captchaUrl) return;
      var uri = Uri.parse(_url);
      if (uri.queryParameters.containsKey("captcha_token")) {
        var _token = uri.queryParameters["captcha_token"];
        if (_token != null) {
          widget.plugin.close();
          _signUp(context, token: _token);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 11, bottom: 31),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.fromBorderSide(BorderSide(
              color: primaryColor,
              width: 1,
            )),
            borderRadius: BorderRadius.all(Radius.circular(3))
          ),
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Text('Sign Up'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => _openCaptcha(context)
          ),
        ),
      ]
    );
  }

  void _openCaptcha(BuildContext context) {
    ScopedModel.of<SignupErrorModel>(context).clearErrors();
    if (token != null) token = null;

    widget.plugin.launch(captchaUrl);
  }

  void _signUp(BuildContext context, { token }) async {
    print(token);
    // get field values from respective models
    final SignupEmailModel email = ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: false);
    final SignupUsernameModel username = ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: false);
    final SignupPasswordModel password = ScopedModel.of<SignupPasswordModel>(context, rebuildOnChange: false);
    final SignupDateOfBirthModel dateOfBirth = ScopedModel.of<SignupDateOfBirthModel>(context, rebuildOnChange: false);

    print(DateTime.parse(dateOfBirth.value).millisecondsSinceEpoch);
    // execute post request with provided fields and hashed password
    var response = await http.post("$baseSignupUrl/signup", 
      headers: {
        "Content-Type": "application/json"
      },
      body: JsonEncoder().convert({
        "email": email.value,
        "username": username.value,
        "password": crypto.sha256.convert(password.value.codeUnits).toString(),
        "dateOfBirth": dateOfBirth.value.split(' ')[0],
        "token": token
      })
    );

    print(response.statusCode.toString() + "\n" + response.body);

    switch(response.statusCode) {
      case 200:
        _signupSuccessful(context,
          token: response.body,
          email: email.value,
          username: username.value,
          dateOfBirth: dateOfBirth.value.split(' ')[0]
        );
        break;
      case 400:
        _signupBadRequest(context);
        break;
      case 500:
        _signupInternal(context);
        break;
      case 409:
        _signupEmailRegistered(context);
        break;
      case 410:
        _signupUsernameInUse(context); // error on username, trigger onchange
        break;
      case 411:
        _signupTooYoung(context); // dob too young, block
        break;
      case 412:
        _signupTokenInvalid(context); // bad captcha
        break;
      case 413: // unexpected
        //_signupUnexpected(context);
        break;
      case 414: // unexpected, doesn't exist
        //_response200(context);
        break;
      case 415: // unexpected, can't happen
        //_response200(context);
        break;
      case 416: // unexpected, can't happen
        //_response200(context);
        break;
      case 417: // unexpected, can't happen
        //_response200(context);
        break;
      case 418: // unexpected, can't happen
        //_response200(context);
        break;
      case 419: // unexpected
        //_response200(context);
        break;
      case 420: // email used, but not confirmed. Show confirm screen (sends email)
        _signupSuccessful(context,
          token: response.body,
          email: email.value,
          username: username.value,
          dateOfBirth: dateOfBirth.value.split(' ')[0]
        );
        break;
      default:
        _signupUnexpected(context, response.statusCode);
        break;
    }
    // deal with the response based on the error code. 200 = OK, 409 = email in use, 408 = DoB invalid.
  }

}



void _signupSuccessful(BuildContext context, { 
  @required String token, 
  @required String email, 
  @required String username, 
  @required String dateOfBirth }) 
async {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) => SignupConfirmView(
      email: email,
      username: username,
      dateOfBirth: dateOfBirth,
      token: token,
    )
  ));
}

void _signupBadRequest(BuildContext context) {
  SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context);
  errorModel.clearErrors();
  errorModel.error = "badRequest";
  _scrollToTopOfSignupView();
}

void _signupInternal(BuildContext context) {
    SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context);
    errorModel.clearErrors();
    errorModel.error = "internalError";
    _scrollToTopOfSignupView();
}

void _signupEmailRegistered(context) {
  ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false).error = "email";
  ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: false).valid = false;
  _scrollToTopOfSignupView();
}

// currently, a user can register for multiple usernames with the same email. Should delete old username record.
void _signupUsernameInUse(BuildContext context) {
  FocusScope.of(context).requestFocus(ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: false).focusNode);
}

void _signupTooYoung(BuildContext context) {
  SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false);
  errorModel.clearErrors();
  errorModel.error = "dob";
  errorModel.fatal = true;
  _scrollToTopOfSignupView();
}

void _signupTokenInvalid(BuildContext context) {
  SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false);
  errorModel.clearErrors();
  errorModel.error = "token";
  errorModel.fatal = true;
  _scrollToTopOfSignupView();
}
void _signupUnexpected(BuildContext context, int statusCode) {
  SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false);
  errorModel.clearErrors();
  errorModel.error = "unexpected";
  _scrollToTopOfSignupView();

}

void _emailInvalid(BuildContext context) async {}
void _dateOfBirthInvalid(BuildContext context) async {}
void _unknownError(BuildContext context) async {}


void _scrollToTopOfSignupView() {
  SignupViewScrollController.controller.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
}
