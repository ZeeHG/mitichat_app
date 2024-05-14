import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/welcomePage/welcomePage_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';
import '../../routes/app_navigator.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() {
    DataSp.putfirstUse(false);
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  final List<ImageView> pages = [
    ImageLibrary.welcome1.toImage,
    ImageLibrary.welcome2.toImage,
    ImageLibrary.welcome3.toImage,
    ImageLibrary.welcome4.toImage,
    ImageLibrary.welcome5.toImage,
  ];

  final List<String> texts = [
    "Free Audio & Video Calls",
    "Thoughtful AI Assistant",
    "Across 60+ Languages",
    "Comprehensive Social Interaction",
    "Multi-Server Support",
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      18.verticalSpace,
                      Text(
                        texts[index],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      12.verticalSpace,
                      pages[index],
                      28.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 21.33.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(pages.length, (indexDots) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: _currentPage == indexDots ? 24.w : 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    color: _currentPage == indexDots
                                        ? Colors.black
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(
                                        _currentPage == indexDots ? 4.w : 4.h),
                                  ),
                                );
                              }),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_currentPage == pages.length - 1) {
                                AppNavigator.startLogin();
                              } else {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut);
                              }
                            },
                            child: Text(
                              _currentPage == pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
