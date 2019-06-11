import 'package:bears_flutter/flows/signup/components/shared/border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model.dart';

class PasswordInputRow extends StatefulWidget {

  @override
  _PasswordInputRowState createState() => _PasswordInputRowState();
}

class _PasswordInputRowState extends State<PasswordInputRow> {
  
  bool initiated = false;
  SignupPasswordModel model;
  bool obscureText = true;
  Function onFieldSubmitted;
  TextInputAction textInputAction;
  List<TextInputFormatter> inputFormatters;
  int maxLength;
  TextInputType textInputType;
  TextEditingController controller;
  FocusNode focusNode;



  @override
  Widget build(BuildContext context) {
    if (!initiated) {
      model = ScopedModel.of<SignupPasswordModel>(context, rebuildOnChange: false);
      setState(() {
        focusNode = model.focusNode;
        onFieldSubmitted = model.onFieldSubmitted;
        textInputAction = model.textInputAction;
        inputFormatters = model.inputFormatters;
        maxLength = model.maxLength;
        textInputType = model.textInputType;
        controller = model.controller;
        initiated = true;
      });
    }
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        BorderBox<SignupPasswordModel>(focus: focusNode),
        Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 3.5),
          child: TextFormField(
            onFieldSubmitted: (String _) => onFieldSubmitted(context),
            textInputAction: textInputAction,
            scrollPadding: EdgeInsets.all(0),
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            keyboardType: textInputType,
            obscureText: obscureText,
            style: TextStyle(
              height: 1,
              fontSize: 15,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w400,
            ),
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              counter: Container(height: 0, width: 0,),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 13),
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              if (mounted) setState(() => obscureText = !obscureText);
            },
            child: Container(
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  _removeRedEye,
                  !obscureText ? _denied : Container()
                ],
              ),
            )
          )
        )
      ],
    );
  }
}

Icon _removeRedEye = Icon(Icons.remove_red_eye, color: Colors.grey[500],);

RotationTransition _denied = RotationTransition(
  turns: AlwaysStoppedAnimation(-45 / 360),
  child: _remove
);

Container _remove = Container(
  height: 4,
  width: 25,
  color: Colors.grey,
);