import 'package:bears_flutter/components/text/information_text.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/utils/weblink.dart';
import 'package:flutter/material.dart';

class SignupLegalese extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: <Widget>[
          ...mapInformationText('By clicking Sign Up, you are indicating that you have read and agree to the'),
          webLink(termsUrl, 'Terms'),
          webLink(termsUrl, ' of '),
          webLink(termsUrl, 'Service'),
          informationText(" and "),
          webLink(privacyUrl, 'Privacy Policy'),
        ],
      )
    );
  }
}

List<Text> mapInformationText(String input) => input.split(' ').map((String word) => Text("$word ", style: TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
))).toList();