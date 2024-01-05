import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'privacy_policy_logic.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrRes.privacyPolicy,
        ),
        backgroundColor: Styles.c_FFFFFF,
        body: SingleChildScrollView(
            child: Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: DefaultTextStyle(
                    style: Styles.ts_333333_13sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boldText(StrRes.privacyPolicy1),
                        boldText(StrRes.privacyPolicy2),
                        regularText(StrRes.privacyPolicy3),
                        regularText(StrRes.privacyPolicy4),
                        regularText(StrRes.privacyPolicy5),
                        regularText(StrRes.privacyPolicy6),
                        regularText(StrRes.privacyPolicy7),
                        regularText(StrRes.privacyPolicy8),
                        boldText(StrRes.privacyPolicy9),
                        regularText(StrRes.privacyPolicy10),
                        regularText(StrRes.privacyPolicy11),
                        regularText(StrRes.privacyPolicy12),
                        regularText(StrRes.privacyPolicy13),
                        regularText(StrRes.privacyPolicy14),
                        regularText(StrRes.privacyPolicy15),
                        regularText(StrRes.privacyPolicy16),
                        regularText(StrRes.privacyPolicy17),
                        regularText(StrRes.privacyPolicy18),
                        regularText(StrRes.privacyPolicy19),
                        regularText(StrRes.privacyPolicy20),
                        boldText(StrRes.privacyPolicy21),
                        regularText(StrRes.privacyPolicy22),
                        regularText(StrRes.privacyPolicy23),
                        regularText(StrRes.privacyPolicy24),
                        regularText(StrRes.privacyPolicy25),
                        regularText(StrRes.privacyPolicy26),
                        boldText(StrRes.privacyPolicy27),
                        regularText(StrRes.privacyPolicy28),
                        regularText(StrRes.privacyPolicy29),
                        regularText(StrRes.privacyPolicy30),
                        boldText(StrRes.privacyPolicy31),
                        regularText(StrRes.privacyPolicy32),
                        regularText(StrRes.privacyPolicy33),
                        regularText(StrRes.privacyPolicy34),
                        regularText(StrRes.privacyPolicy35),
                        regularText(StrRes.privacyPolicy36),
                        regularText(StrRes.privacyPolicy37),
                        regularText(StrRes.privacyPolicy38),
                        regularText(StrRes.privacyPolicy39),
                        regularText(StrRes.privacyPolicy40),
                        regularText(StrRes.privacyPolicy41),
                        regularText(StrRes.privacyPolicy42),
                        regularText(StrRes.privacyPolicy43),
                        regularText(StrRes.privacyPolicy44),
                        regularText(StrRes.privacyPolicy45),
                        regularText(StrRes.privacyPolicy46),
                        regularText(StrRes.privacyPolicy47),
                        regularText(StrRes.privacyPolicy48),
                        regularText(StrRes.privacyPolicy49),
                        regularText(StrRes.privacyPolicy50),
                        regularText(StrRes.privacyPolicy51),
                        regularText(StrRes.privacyPolicy52),
                        boldText(StrRes.privacyPolicy53),
                        regularText(StrRes.privacyPolicy54),
                        regularText(StrRes.privacyPolicy55),
                        regularText(StrRes.privacyPolicy56),
                        regularText(StrRes.privacyPolicy57),
                        regularText(StrRes.privacyPolicy58),
                        boldText(StrRes.privacyPolicy59),
                        regularText(StrRes.privacyPolicy60),
                        regularText(StrRes.privacyPolicy61),
                        regularText(StrRes.privacyPolicy62),
                        regularText(StrRes.privacyPolicy63),
                        regularText(StrRes.privacyPolicy64),
                        regularText(StrRes.privacyPolicy65),
                        regularText(StrRes.privacyPolicy66),
                        regularText(StrRes.privacyPolicy67),
                        regularText(StrRes.privacyPolicy68),
                        regularText(StrRes.privacyPolicy69),
                        regularText(StrRes.privacyPolicy70),
                        regularText(StrRes.privacyPolicy71),
                        regularText(StrRes.privacyPolicy72),
                        boldText(StrRes.privacyPolicy73),
                        regularText(StrRes.privacyPolicy74),
                        regularText(StrRes.privacyPolicy75),
                        regularText(StrRes.privacyPolicy76),
                        regularText(StrRes.privacyPolicy77),
                        regularText(StrRes.privacyPolicy78),
                        regularText(StrRes.privacyPolicy79),
                        regularText(StrRes.privacyPolicy80),
                        regularText(StrRes.privacyPolicy81),
                        regularText(StrRes.privacyPolicy82),
                        regularText(StrRes.privacyPolicy83),
                        regularText(StrRes.privacyPolicy84),
                        regularText(StrRes.privacyPolicy85),
                        regularText(StrRes.privacyPolicy86),
                        regularText(StrRes.privacyPolicy87),
                        regularText(StrRes.privacyPolicy88),
                        regularText(StrRes.privacyPolicy89),
                        regularText(StrRes.privacyPolicy90),
                        regularText(StrRes.privacyPolicy91),
                        regularText(StrRes.privacyPolicy92),
                        regularText(StrRes.privacyPolicy93),
                        regularText(StrRes.privacyPolicy94),
                        regularText(StrRes.privacyPolicy95),
                        boldText(StrRes.privacyPolicy96),
                        regularText(StrRes.privacyPolicy97),
                        boldText(StrRes.privacyPolicy98),
                        regularText(StrRes.privacyPolicy99),
                        regularText(StrRes.privacyPolicy100),
                        regularText(StrRes.privacyPolicy101),
                        boldText(StrRes.privacyPolicy102),
                        regularText(StrRes.privacyPolicy103),
                        regularText(StrRes.privacyPolicy104),
                        regularText(StrRes.privacyPolicy105),
                        regularText(StrRes.privacyPolicy106),
                        regularText(StrRes.privacyPolicy107),
                        boldText(StrRes.privacyPolicy108),
                        regularText(StrRes.privacyPolicy109),
                        boldText(StrRes.privacyPolicy110),
                        regularText(StrRes.privacyPolicy111),
                        boldText(StrRes.privacyPolicy112),
                        regularText(StrRes.privacyPolicy113),
                        boldText(StrRes.privacyPolicy114),
                        regularText(StrRes.privacyPolicy115),
                        boldText(StrRes.privacyPolicy116),
                        regularText(StrRes.privacyPolicy117),
                        regularText(StrRes.privacyPolicy118),
                      ],
                    )))));
  }

  Container boldText(String text) => Container(
        margin: EdgeInsets.only(bottom: 13.h),
        child: text.toText..style = Styles.ts_333333_13sp_medium,
      );

  Container regularText(String text) => Container(
        margin: EdgeInsets.only(bottom: 13.h),
        child: text.toText..style = Styles.ts_333333_13sp,
      );

  RichText richText(List<TextSpan> children) => RichText(
    text: TextSpan(
      children: children,
    ),
  );

  TextSpan boldTextSpan(String text) => TextSpan(text: text, style: Styles.ts_333333_13sp_medium);

  TextSpan regularTextSpan(String text) => TextSpan(text: text, style: Styles.ts_333333_13sp);
}
