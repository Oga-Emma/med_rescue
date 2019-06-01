import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/onboarding/third_screen.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

import 'first_screen.dart';
import 'onboarding_page_holder.dart';
import 'second_screen.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final controller = PageController(initialPage: 0);
  int currentPage = 0;
  final pages =  <Widget>[
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: PageView(
              controller: controller,
              children: pages,
              onPageChanged: (int page) {
//                print("Current Page: " + page.toString());
                setState(() {
                  currentPage = ++page;
                });
//                int previousPage = page;
//                if(page != 0) previousPage--;
//                else previousPage = 2;
//                print("Previous page: $previousPage");
              },
            ),),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  gap(height: 16),
                  SizedBox(
                    height: 46,
                    width: double.maxFinite,
                    child: RaisedButton(
                      onPressed: () {
//                        controller.nextPage();
                      if(currentPage <= 2) {
                        currentPage += currentPage;
                        print("Changing");
//                        print(currentPage.toString());
                        controller.animateToPage(currentPage++,
                            duration: Duration(milliseconds: 500), curve: Curves.easeOutQuart);
                      }else{
                        print("Last");
                      }
                      },
                      child: Text(
                        currentPage == pages.length ? "Finish" : "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: primaryColor,
                    ),
                  ),
                  gap(height: 16),
                  FlatButton(onPressed: () {
                  }, child: Text("Skip")),
                  gap(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[dot(currentPage == 0), dot(currentPage == 1), dot(currentPage == 2)],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
