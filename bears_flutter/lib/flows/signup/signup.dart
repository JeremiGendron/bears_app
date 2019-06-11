import 'package:bears_flutter/components/app_bars/app_bars.dart';
import 'package:bears_flutter/components/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bears_flutter/flows/signup/components/standard_input.dart';

import 'components/button.dart';
import 'components/error.dart';
import 'components/legalese.dart';
import 'models/date_of_birth.dart';
import 'models/email.dart';
import 'models/error.dart';
import 'models/password/model.dart';
import 'models/username.dart';
import 'scroll_controller.dart';



class SignupView extends StatelessWidget {
  final SignupErrorModel signupErrorModel = SignupErrorModel();
  final SignupEmailModel signupEmailModel = SignupEmailModel();
  final SignupUsernameModel signupUsernameModel = SignupUsernameModel();
  final SignupPasswordModel signupPasswordModel = SignupPasswordModel();
  final SignupDateOfBirthModel signupDateOfBirthModel = SignupDateOfBirthModel();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: standardAppBar('Sign Up'),
      body: SingleChildScrollView(
        controller: SignupViewScrollController.controller,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ScopedModel<SignupErrorModel>(
          model: signupErrorModel,
          child: ScopedModel<SignupEmailModel>(
          model: signupEmailModel,
          child: ScopedModel<SignupUsernameModel>(
          model: signupUsernameModel,
          child: ScopedModel<SignupPasswordModel>(
          model: signupPasswordModel,
          child: ScopedModel<SignupDateOfBirthModel>(
          model: signupDateOfBirthModel,
          child: Column(
            children: <Widget>[
              topSpacer(20),
              SignupError(),
              _signupEmail,
              _signupUsername,
              _signupPassword,
              _signupDateOfBirth,
              SignupLegalese(),
              SignupButton(),
            ],
                    ),
          ),
          ),
          ),
          ),
          ),
        ),
      ),
    );
  }

}

SignupStandardInputComponent _signupEmail = SignupStandardInputComponent<SignupEmailModel>();
SignupStandardInputComponent _signupUsername = SignupStandardInputComponent<SignupUsernameModel>();
SignupStandardInputComponent _signupPassword = SignupStandardInputComponent<SignupPasswordModel>();
SignupStandardInputComponent _signupDateOfBirth = SignupStandardInputComponent<SignupDateOfBirthModel>();