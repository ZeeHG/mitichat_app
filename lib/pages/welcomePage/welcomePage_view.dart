import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/welcomePage/welcomePage_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class SwiperPage extends StatelessWidget {
  SwiperPage({super.key});
  List<String> imgs = [
    'assets/images/welcome1.png',
    'assets/images/welcome2.png',
    'assets/images/welcome3.png',
    'assets/images/welcome4.png',
    'assets/images/welcome5.png',
  ];
  List<String> texts = [
    "Free Audio & Video Calls",
    "Thoughtful AI Assistant",
    "Across 60+ Languages",
    "Comprehensive Social Interaction"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        texts[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        imgs[index],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
                  );
                },
                itemCount: imgs.length,
                autoplay: false,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Colors.black,
                  activeColor: Colors.black,
                  size: 8.0,
                  activeSize: 12.0,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
