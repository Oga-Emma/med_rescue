import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class OnboardingPageHolder extends StatefulWidget {
  OnboardingPageHolder({this.position, this.onNext, this.child});

  final Widget child;
  final void Function(bool lastPage) onNext;
  final int position;

  @override
  _OnboardingPageHolderState createState() => _OnboardingPageHolderState();
}

class _OnboardingPageHolderState extends State<OnboardingPageHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: widget.child),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                gap(height: 16),
                SizedBox(
                  height: 46,
                  width: double.maxFinite,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: primaryColor,
                  ),
                ),
                gap(height: 16),
                FlatButton(onPressed: () {
                  if(widget.onNext != null) {
                    widget.onNext(false);
                  }
                }, child: Text("Skip")),
                gap(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[dot(true), dot(), dot(), dot()],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

