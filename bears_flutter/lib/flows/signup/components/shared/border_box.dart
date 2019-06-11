import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BorderBox<_Model extends SignupStandardInputModel> extends StatefulWidget {

  final FocusNode focus;

  BorderBox({
    @required this.focus,
  });

  @override
  State<StatefulWidget> createState() {
    return _BorderBoxState<_Model>();
  }

}

class _BorderBoxState<_Model extends SignupStandardInputModel> extends State<BorderBox> {
  
  bool focused = false;

  _BorderBoxState();

  @override
  void initState() {
    widget.focus.addListener(() {
      if (widget.focus.hasFocus && !focused) setState(() => focused = true);
      if (!widget.focus.hasFocus && focused) setState(() => focused = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SignupStandardInputModel model = ScopedModel.of<_Model>(context, rebuildOnChange: true);
    final bool valid = model.valid?? false;
    final bool dirty = model.dirty?? false;

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: 45
      ),
      decoration: BoxDecoration(
        border: !valid && dirty ? _errorBorder() : 
                !dirty && focused ? _focusedBorder() :
                _normalBorder(),
        borderRadius: BorderRadius.circular(4)
      ),
    );
  }

}

Border _errorBorder() => Border.fromBorderSide(BorderSide(
  color: Colors.red,
  width: 2,
));
Border _focusedBorder() => Border.fromBorderSide(BorderSide(
  color: primaryColor,
  width: 2,
));
Border _normalBorder() => Border.fromBorderSide(BorderSide(
  color: Colors.grey
));