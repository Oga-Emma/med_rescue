import 'package:flutter/material.dart';
import 'package:med_rescue/model/signup_dto.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/util/validator.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class SignUpStage1 extends StatefulWidget {
  SignUpStage1({this.onNext, this.signUpDTO});
  final UserDTO signUpDTO;
  final Function(bool last) onNext;

  @override
  _SignUpStage1State createState() => _SignUpStage1State();
}

class _SignUpStage1State extends State<SignUpStage1> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              gap(height: 24),
              Text("Step 1", style: TextStyle(color: Colors.grey),),
              Container(height: 1, width: 42, color: primaryColor, margin: EdgeInsets.only(top: 8.0),),
              gap(height: 24),
              TextFormField(
                initialValue: widget.signUpDTO.firstName,
                validator: SvValidate.tryString("First name is required"),
                decoration: InputDecoration(labelText: "First Name"),
                onSaved: (String value){
                  widget.signUpDTO.firstName = value;
                },
              ),
              gap(height: 32),
              TextFormField(
                initialValue: widget.signUpDTO.lastName,
                validator: SvValidate.tryString("Last name is required"),
                decoration: InputDecoration(labelText: "Last Name"),
                onSaved: (String value){
                  widget.signUpDTO.lastName = value;
                },
              ),
              gap(height: 50),
              SizedBox(
                height: 46,
                width: double.maxFinite,
                child: RaisedButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      widget.onNext(false);
                    }
                  },
                  child: Text("Next",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor,
                ),
              ),
              gap(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
