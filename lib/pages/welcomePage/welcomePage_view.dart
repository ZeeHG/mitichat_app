import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
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
  final List<ImageView> pages = [
    ImageLibrary.welcome1.toImage,
    ImageLibrary.welcome2.toImage,
    ImageLibrary.welcome3.toImage,
    ImageLibrary.welcome4.toImage,
    ImageLibrary.welcome5.toImage,
  ];

  final List<List<String>> texts = [
    ["Free Audio &", "Video Calls"],
    ["Thoughtful", "AI Assistant"],
    ["Across 60+", "Languages"],
    ["Comprehensive", "Social Interaction"],
    ["Multi-Server", "Support"],
  ];

  int _currentPage = 0;
  final SwiperController _swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Swiper(
              controller: _swiperController,
              itemCount: pages.length,
              loop: false,
              onIndexChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    96.05.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 28.63.w, right: 70.61.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            texts[index][0],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'HelveticaNowText',
                              letterSpacing: 0.0,
                              height: 36 / 34,
                              color: Color(0xFF212121),
                            ),
                          ),
                          Text(
                            texts[index][1],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'HelveticaNowText',
                              letterSpacing: 0.0,
                              height: 36 / 34,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                    34.35.verticalSpace,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300.h,
                      child: pages[index],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.53.w, 61.07.h, 30.53.w, 62.02.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (indexDots) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: _currentPage == indexDots ? 26.w : 9.w,
                      height: 9.h,
                      margin: EdgeInsets.symmetric(
                          vertical: 8.59.w, horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: _currentPage == indexDots
                            ? Color(0xFF212121)
                            : Color(0xFF212121),
                        borderRadius: BorderRadius.circular(
                            _currentPage == indexDots ? 4.w : 4.h),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: 88.w,
                  height: 38.h,
                  child: TextButton(
                    onPressed: () {
                      if (_currentPage == pages.length - 1) {
                        AppNavigator.startLogin();
                      } else {
                        _swiperController.next();
                      }
                    },
                    child: Text(
                      _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF7A27FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      minimumSize: Size(88.w, 38.h),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
