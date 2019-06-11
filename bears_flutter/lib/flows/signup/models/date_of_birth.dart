import 'package:bears_flutter/flows/signup/components/shared/border_box.dart';
import 'package:bears_flutter/flows/signup/models/standard_input.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
class SignupDateOfBirthModel extends SignupStandardInputModel {

  @override
  Widget fieldRow = SignupDateOfBirthFieldRow();

  @override String validate(String input) {
    if (DateTime.tryParse(input) == null) {
      super.valid = false;
      super.value = "";
      controller.text = "";
      return "empty";
    }
    String result = input.length > 1 ? "ok": "empty";
    String formatted = result == "ok" ? formatDate(input) : "";
    super.valid = result == "ok";
    super.value = input;
    controller.text = formatted;
    return result;
  } 

  @override void onChange(String input) => null;

  @override final String name = 'date of birth';

  @override final String display = 'Date of Birth';

  @override final Widget headerStatus = Container();

  @override final TextInputType textInputType = TextInputType.datetime;

  @override final TextEditingController controller = TextEditingController();

  @override final FocusNode focusNode = FocusNode();

  @override final bool autoFocus = false;

  @override void onFieldSubmitted(BuildContext context) {
    FocusScope.of(context).detach();
  }
  
  @override TextInputAction textInputAction = TextInputAction.next;

  @override Map<String, Widget> hints = {
    "ok": Container(),
    "empty": Container()
  };

  @override Map<String, bool> validity = {
    "ok": true,
    "empty": false
  };
}

String formatDate(String input) {
  String date = input.split(' ')[0];
  List<String> splits = date.split('-');
  print(splits);
  return "${_months[splits[1]]} ${splits[2]}, ${splits[0]}";
}

Map <String, String> _months = {
 "01": "Jan",
 "02": "Feb",
 "03": "Mar",
 "04": "Apr",
 "05": "May",
 "06": "Jun",
 "07": "Jul",
 "08": "Aug",
 "09": "Sep",
 "10": "Oct",
 "11": "Nov",
 "12": "Dec",
};

class SignupDateOfBirthFieldRow extends StatefulWidget {
  @override
  _SignupDateOfBirthFieldRowState createState() => _SignupDateOfBirthFieldRowState();
}

class _SignupDateOfBirthFieldRowState extends State<SignupDateOfBirthFieldRow> {
  FocusNode focusNode;
  bool initiated = false;
  Function onFieldSubmitted;
  TextInputAction textInputAction;
  TextEditingController controller;
  PersistentBottomSheetController bottomSheetController;

  void closeBottomSheetController() => bottomSheetController.close();

  @override
  Widget build(BuildContext context) {
    if (!initiated) {
      SignupDateOfBirthModel model = ScopedModel.of<SignupDateOfBirthModel>(context, rebuildOnChange: false);
      model.onChange("");
      setState(() {
        onFieldSubmitted = model.onFieldSubmitted;
        textInputAction = model.textInputAction;
        controller = model.controller;
        focusNode = model.focusNode;
        focusNode.addListener(() async {
          if (focusNode.hasFocus) {
            FocusScope.of(context).detach();
            DateTime picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1900, 1, 1),
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked.toString().length > 0) model.validate(picked.toString());
          }
        });
        initiated = true;
      });
    }
    
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        BorderBox<SignupDateOfBirthModel>(focus: focusNode),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3.5),
          child: TextFormField(
            controller: controller,
            textInputAction: textInputAction,
            scrollPadding: EdgeInsets.all(0),
            style: TextStyle(
              height: 1,
              fontSize: 15,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w400,
            ),
            focusNode: focusNode,
            decoration: InputDecoration(
              counter: Container(height: 0, width: 0,),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}