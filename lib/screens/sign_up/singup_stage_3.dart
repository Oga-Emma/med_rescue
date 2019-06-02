import 'package:flutter/material.dart';
import 'package:med_rescue/model/signup_dto.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/util/validator.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class SignUpStage3 extends StatefulWidget {
  SignUpStage3({this.onNext, this.signUpDTO});
  final UserDTO signUpDTO;
  final Function(bool last) onNext;



  @override
  _SignUpStage3State createState() => _SignUpStage3State();
}

class _SignUpStage3State extends State<SignUpStage3> {
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
              Text("Step 3", style: TextStyle(color: Colors.grey),),
              Container(height: 1, width: 42, color: primaryColor, margin: EdgeInsets.only(top: 8.0),),
              gap(height: 24),
              TextFormField(
                initialValue: widget.signUpDTO.organizationName,
                validator: SvValidate.tryString("Invalid input"),
                decoration: InputDecoration(labelText: "Name of Organization"),
                onSaved: (String value){
                  widget.signUpDTO.organizationName = value;
                },
              ),
              gap(height: 32),
              TextFormField(
                initialValue: widget.signUpDTO.organizationCode,
                validator: SvValidate.tryString("Invalid input"),
                decoration: InputDecoration(labelText: "Organization Code"),
                onSaved: (String value){
                  widget.signUpDTO.organizationCode = value;
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
                      widget.onNext(true);
                    }
                  },
                  child: Text("Finish",
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
