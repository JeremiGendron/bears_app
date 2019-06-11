import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FieldHint<_Model extends SignupStandardInputModel> extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Widget hintWidget = ScopedModel.of<_Model>(context, rebuildOnChange: true).hintWidget?? Container();


    return hintWidget;
  }
}
