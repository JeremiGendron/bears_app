import 'package:bears_flutter/components/badges/badges.dart';
import 'package:bears_flutter/components/spacing/bottom_spacer.dart';
import 'package:bears_flutter/components/text/text.dart';
import 'package:bears_flutter/flows/signup/components/shared/field_hint.dart';
import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:bears_flutter/utils/capitalize.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'shared/border_box.dart';
import 'package:flutter/material.dart';

class SignupStandardInputComponent<_Model extends SignupStandardInputModel> extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final SignupStandardInputModel model = ScopedModel.of<_Model>(context, rebuildOnChange: false);
    final Widget headerStatus = model.headerStatus?? StandardHeaderStatus<_Model>();
    final TextEditingController controller = model.controller;
    final String display = model.display;
    final Widget fieldRow = model.fieldRow?? SignupStandardFieldRow<_Model>();


    controller.addListener(() =>
      model.onChange(controller.value.text)
    );

    
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          bottomSpacer(11),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              fieldHeaderText(capitalize(display)),
              headerStatus
              
            ],
          ),
          bottomSpacer(10),
          Container(
            constraints: BoxConstraints(
              maxHeight: 54,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: fieldRow
            )
          ),
          bottomSpacer(10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FieldHint<_Model>()
            ],
          ),
          bottomSpacer(11)
        ],
      ),
    );
  }
}

class SignupStandardFieldRow<_Model extends SignupStandardInputModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _Model model = ScopedModel.of<_Model>(context, rebuildOnChange: false);
    final Function onFieldSubmitted = model.onFieldSubmitted;
    final TextInputAction textInputAction = model.textInputAction;
    final List<TextInputFormatter> inputFormatters = model.inputFormatters;
    final int maxLength = model.maxLength;
    final TextInputType textInputType = model.textInputType;
    final TextEditingController controller = model.controller;
    final FocusNode focusNode = model.focusNode;
    final bool autoFocus = model.autoFocus;
    
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        BorderBox<_Model>(focus: focusNode),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3.5),
            child: TextFormField(
                autofocus: autoFocus,
                onFieldSubmitted: (String _) => onFieldSubmitted(context),
                textInputAction: textInputAction,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                keyboardType: textInputType,
                obscureText: false,
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
      ],
    );
  }
}

class StandardHeaderStatus<_Model extends SignupStandardInputModel> extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final _Model model = ScopedModel.of<_Model>(context, rebuildOnChange: true);
    final bool valid = model.valid?? false;
    final bool dirty = model.dirty?? false;
    final bool loading = model.loading;
    final int length = model.value == null ? 0 : model.value.length;

    return loading && dirty ? loadingBadge() :
           dirty && length == 0 ? errorBadge() :
           dirty && !valid ? errorBadge() :
           dirty && valid ? checkmarkBadge() :
           Container();
  }
  
}