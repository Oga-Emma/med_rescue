import 'package:flutter/material.dart';
import 'package:med_rescue/model/signup_dto.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/util/validator.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class SignUpStage2 extends StatefulWidget {
  SignUpStage2({this.onNext, this.signUpDTO});
  final UserDTO signUpDTO;
  final Function(bool last) onNext;



  @override
  _SignUpStage2State createState() => _SignUpStage2State();
}

class _SignUpStage2State extends State<SignUpStage2> {
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
              Text("Step 2 ", style: TextStyle(color: Colors.grey),),
              Container(height: 1, width: 42, color: primaryColor, margin: EdgeInsets.only(top: 8.0),),
              gap(height: 24),
              TextFormField(
                initialValue: widget.signUpDTO.email,
                keyboardType: TextInputType.emailAddress,
                validator: SvValidate.tryEmail("Invalid email"),
                decoration: InputDecoration(labelText: "Email Address"),
                onSaved: (String value){
                  widget.signUpDTO.email = value;
                },
              ),
              gap(height: 32),
              TextFormField(
                initialValue: widget.signUpDTO.phoneNumber,
                keyboardType: TextInputType.phone,
                validator: SvValidate.tryPhone("Invalid phone number"),
                decoration: InputDecoration(labelText: "Phone Number"),
                onSaved: (String value){
                  widget.signUpDTO.phoneNumber = value;
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
