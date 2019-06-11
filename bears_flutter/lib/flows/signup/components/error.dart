import 'package:bears_flutter/components/badges/badges.dart';
import 'package:bears_flutter/components/spacing/bottom_spacer.dart';
import 'package:bears_flutter/components/spacing/right_spacer.dart';
import 'package:bears_flutter/components/text/text.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/flows/signup/models/error.dart';
import 'package:bears_flutter/utils/weblink.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = ScopedModel.of<SignupErrorModel>(context, rebuildOnChange: true).error;

    return error != null ? Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border(
          left: _leftBorderSide(),
          top: _standardBorderSide(),
          right: _standardBorderSide(),
          bottom: _standardBorderSide(),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          errorBadge(),
          rightSpacer(10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _errorHeader(error),
                bottomSpacer(10),
                _errorMessage(error)
              ],
            ),
          ),
          bottomSpacer(20)
        ],
      ),
    ):
    Container();
  }
}

final Map<String, String> _errorHeaderTexts = {
  "email": "Unable to create account.",
  "dob": "Sorry, you must be at least 13 years old to create an account.",
  "token": "Failed security test.",
  "badRequest": "Please try again",
  "internalError": "Oops, that's on our end.",
  "unexpected": "An unexpected error occurred.",
  "code": "Code validation error.",
  "username": "Please use another username."
};

final Map<String, Widget> _errorMessageTexts = {
  "email": informationText('Please use a different email address to continue.'),
  "dob": Wrap(
    direction: Axis.horizontal,
    children: <Widget>[
      informationText('To learn more, please read our '),
      webLink(termsUrl, 'terms of service.')
    ],
  ),
  "token": informationText("We are unable to conduct your registration due to security concerns."),
  "badRequest": informationText("An issue occurred with the credentials you provided."),
  "internalError": informationText("A blunder happened, sometimes restarting the app will help with that."),
  "unexpected": informationText("The service might be down at the moment."),
  "code": informationText("The code you provided is either invalid or has expired."),
  "username": informationText("This username was claimed while you were Signing Up. We're sorry about that.")
};

Widget _errorHeader(String error) => Text(_errorHeaderTexts[error], style: TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.bold
));

Widget _errorMessage(String error) => _errorMessageTexts[error];

BorderSide _leftBorderSide() => BorderSide(
  color: Colors.red,
  width: 4
);
BorderSide _standardBorderSide() => BorderSide(
  color: Colors.red,
  width: 1
);