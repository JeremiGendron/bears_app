import 'dart:convert';

import 'package:bears_flutter/components/app_bars/app_bars.dart';
import 'package:bears_flutter/components/spacing/bottom_spacer.dart';
import 'package:bears_flutter/components/spacing/top_spacer.dart';
import 'package:bears_flutter/components/text/information_text.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/flows/signup/components/error.dart';
import 'package:bears_flutter/flows/signup/confirm/helper.dart';
import 'package:bears_flutter/flows/signup/models/email.dart';
import 'package:bears_flutter/flows/signup/models/error.dart';
import 'package:bears_flutter/flows/signup/models/username.dart';
import 'package:bears_flutter/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class SignupConfirmViewScrollController {
  static final ScrollController controller = ScrollController();
  static void scrollToTop() => controller.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.ease);
}

class SignupConfirmView extends StatelessWidget {
  final String token;
  final String email;
  final String username;
  final String dateOfBirth;
  final TextEditingController controller = TextEditingController();

  SignupConfirmView({
    @required this.token,
    @required this.email,
    @required this.username,
    @required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.topCenter,
        constraints: BoxConstraints(
          maxWidth: 500
        ),
        child: SingleChildScrollView(
          controller: SignupConfirmViewScrollController.controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              topSpacer(20),
              SignupError(),
              _title,
              topSpacer(15),
              _instructions(email),
              topSpacer(15),
              info,
              topSpacer(15),
              SignupConfirmInput(token: token, email: email, username: username, dateOfBirth: dateOfBirth),
              topSpacer(16),
              SignupSubmitButton(token: token, email: email, username: username, dateOfBirth: dateOfBirth),
              topSpacer(15),
              SignupResendButton(token: token, email: email, username: username, dateOfBirth: dateOfBirth),
              bottomSpacer(20)

            ],
          ),
        ),
      )
    );
  }

}

class SignupResendButton extends StatelessWidget {

  final String token;
  final String email;
  final String username;
  final String dateOfBirth;

  SignupResendButton({
    @required this.token,
    @required this.email,
    @required this.username,
    @required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: OutlineButton(
        child: Text('Resend code'),
        onPressed: _resend,
        textColor: primaryColor,
        borderSide: BorderSide(
          width: 1,
          color: primaryColor,
        ),
      ),
    );
  }

  void _resend() async {
// check if registered, if so route to email error
  }
}

class SignupSubmitButton extends StatefulWidget {

  final String token;
  final String email;
  final String username;
  final String dateOfBirth;
  
  SignupSubmitButton({
    @required this.token,
    @required this.email,
    @required this.username,
    @required this.dateOfBirth,
  });

  @override
  _SignupSubmitButtonState createState() => _SignupSubmitButtonState();
}

class _SignupSubmitButtonState extends State<SignupSubmitButton> {

  bool valid = false;

  @override
  void initState() {
    SignupConfirmHelper.controller.addListener(() {
      if (SignupConfirmHelper.controller.text.length > 0) {
        if (valid != true) setState(() => valid = true);
      }
      else setState(() => valid = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: valid ? primaryColor : Colors.grey[200],
        border: Border.fromBorderSide(BorderSide(
          color: valid ? primaryColor : Colors.grey[500],
          width: 1,
        )),
        borderRadius: BorderRadius.all(Radius.circular(3))

      ),

      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        onPressed: valid ? () => _confirm(email: widget.email, token: widget.token, username: widget.username, dateOfBirth: widget.dateOfBirth, context: context) : null,
        color: primaryColor,
        disabledColor: Colors.grey[200],
        child: Text('Submit', style: TextStyle(color: valid ? Colors.white : Colors.grey[500],),),
      ),
    );
  }
}

class SignupConfirmInput extends StatelessWidget {
    final String token;
  final String email;
  final String username;
  final String dateOfBirth;

  SignupConfirmInput({
    @required this.token,
    @required this.email,
    @required this.username,
    @required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: SignupConfirmHelper.controller,
        onEditingComplete: SignupConfirmHelper.controller.text.length > 0 ? 
          () {
            FocusScope.of(context).detach();
            _confirm(email: email, dateOfBirth: dateOfBirth, token: token, username: username, context: context); 
          }: null,
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly
        ],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 1
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2
            )
          )
        ),
      ),
    );
  }
}

Text _title = Text('Please verify your Bears Group account.', textAlign: TextAlign.center, style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
),);
RichText _instructions(String email) => RichText(
  softWrap: true,
  textAlign: TextAlign.center,
  text: TextSpan(
    text: 'Enter the code sent to ',
    style: TextStyle(fontSize: 16, color: Colors.black),
    children: [
      TextSpan(text: email, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,))
    ] 
  )
);
Text info = informationText("Verify your account to mark your presence in the community. Some features can't be accessed without a verified account.", alignment: TextAlign.center);

void _confirm({String email, String token, String username, String dateOfBirth, BuildContext context}) async {
  var response = await http.post('$baseSignupUrl/confirm',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JsonEncoder().convert({
      "email": email,
      "token": token,
      "username": username,
      "dateOfBirth": dateOfBirth,
      "code": SignupConfirmHelper.controller.text
    })
  );

  switch (response.statusCode) {
    case 200:
      Map body = JsonDecoder().convert(response.body);
      _goToProfile(context: context, userId: body["userId"], loginToken: body["token"], username: username);
      break;
    case 410:
        SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false);
        errorModel.clearErrors();
        errorModel.error = "code";
        SignupConfirmViewScrollController.scrollToTop();
      break;
    case 409:
        SignupErrorModel errorModel = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false);
        SignupUsernameModel usernameModel = ScopedModel.of<SignupUsernameModel>(context, rebuildOnChange: false);
        usernameModel.validate(usernameModel.controller.text);
        errorModel.clearErrors();
        errorModel.error = "username";
        SignupConfirmViewScrollController.scrollToTop();
      break;
    case 420:
      ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: false).error = "email";
      ScopedModel.of<SignupEmailModel>(context, rebuildOnChange: false).valid = false;
      SignupConfirmViewScrollController.scrollToTop();
      break;
    default:
  }

  print(response.statusCode.toString() + response.body);
}

void _goToProfile({ BuildContext context, String userId, String loginToken, String username }) async {
  await ScopedModel.of<UserModel>(context, rebuildOnChange: false).loginUser(
    userId,
    loginToken,
    username
  );

  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) {
      ProfileSettingsView();
    }
  ));
}

class ProfileSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: standardAppBar('Edit Profile'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}