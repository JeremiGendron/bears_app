import 'package:bears_flutter/components/badges/badges.dart';
import 'package:bears_flutter/components/spacing/spacing.dart';
import 'package:bears_flutter/data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model.dart';

class PasswordHeaderStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignupPasswordModel model = ScopedModel.of<SignupPasswordModel>(context, rebuildOnChange: true);
    final String strength = model.strength;
    final bool valid = model.valid;
    final bool dirty = model.dirty;

    return !dirty ? _noPasswordHeader() :
           dirty && !valid ? _invalidPasswordHeader() :
           dirty && valid && strength == 'Weak' ? _weakPasswordHeader() :
           dirty && valid && strength == 'Strong' ? _strongPasswordHeader() :
           _noPasswordHeader();
  }
}

Widget _noPasswordHeader() => Container(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      PasswordStatusBar(color: primaryColorLight, coloredWidth: 42, backgroundWidth: 0,)
    ],
  ),
);

Widget _invalidPasswordHeader() => Container(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      errorBadge(),
      rightSpacer(3),
      PasswordStatusBar()
    ],
  ),
);
Widget _weakPasswordHeader() => Container(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      warningBadge(),
      rightSpacer(3),
      Text('Weak', style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.orange
      ),),
      rightSpacer(3),
      PasswordStatusBar(coloredWidth: 15, backgroundWidth: 27, color: Colors.orange)
    ],
  ),
);
Widget _strongPasswordHeader() => Container(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      checkmarkBadge(),
      rightSpacer(3),
      Text('Strong', style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.green
      ),),
      rightSpacer(3),
      PasswordStatusBar(coloredWidth: 42, backgroundWidth: 0, color: Colors.green)
    ],
  ),
);

class PasswordStatusBar extends StatelessWidget {

  final double coloredWidth;
  final double backgroundWidth;
  final Color color;

  PasswordStatusBar({this.coloredWidth = 0, this.backgroundWidth = 42, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 42),
      height: 5,
      width: 42,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          coloredWidth > 0 ? Container(
            width: coloredWidth,
            height: 5,
            color: color,
          ) : Container(),
          backgroundWidth > 0 ? Container(
            width: backgroundWidth,
            height: 5,
            color: primaryColorLight,
          ) : Container()
        ],
      )
    );
  }
}

