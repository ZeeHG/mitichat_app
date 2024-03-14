import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'privacy_policy_logic.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.privacyPolicy,
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
                        boldText(StrLibrary.privacyPolicy1),
                        boldText(StrLibrary.privacyPolicy2),
                        regularText(StrLibrary.privacyPolicy3),
                        regularText(StrLibrary.privacyPolicy4),
                        regularText(StrLibrary.privacyPolicy5),
                        regularText(StrLibrary.privacyPolicy6),
                        regularText(StrLibrary.privacyPolicy7),
                        regularText(StrLibrary.privacyPolicy8),
                        boldText(StrLibrary.privacyPolicy9),
                        regularText(StrLibrary.privacyPolicy10),
                        regularText(StrLibrary.privacyPolicy11),
                        regularText(StrLibrary.privacyPolicy12),
                        regularText(StrLibrary.privacyPolicy13),
                        regularText(StrLibrary.privacyPolicy14),
                        regularText(StrLibrary.privacyPolicy15),
                        regularText(StrLibrary.privacyPolicy16),
                        regularText(StrLibrary.privacyPolicy17),
                        regularText(StrLibrary.privacyPolicy18),
                        regularText(StrLibrary.privacyPolicy19),
                        regularText(StrLibrary.privacyPolicy20),
                        boldText(StrLibrary.privacyPolicy21),
                        regularText(StrLibrary.privacyPolicy22),
                        regularText(StrLibrary.privacyPolicy23),
                        regularText(StrLibrary.privacyPolicy24),
                        regularText(StrLibrary.privacyPolicy25),
                        regularText(StrLibrary.privacyPolicy26),
                        boldText(StrLibrary.privacyPolicy27),
                        regularText(StrLibrary.privacyPolicy28),
                        regularText(StrLibrary.privacyPolicy29),
                        regularText(StrLibrary.privacyPolicy30),
                        boldText(StrLibrary.privacyPolicy31),
                        regularText(StrLibrary.privacyPolicy32),
                        // regularText(StrLibrary .privacyPolicy33),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy33_1),
                          regularTextSpan(StrLibrary.privacyPolicy33_2)
                        ]),
                        regularText(StrLibrary.privacyPolicy34),
                        regularText(StrLibrary.privacyPolicy35),
                        // regularText(StrLibrary .privacyPolicy36),
                        // regularText(StrLibrary .privacyPolicy37),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy36_1),
                          regularTextSpan(StrLibrary.privacyPolicy36_2)
                        ]),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy37_1),
                          regularTextSpan(StrLibrary.privacyPolicy37_2)
                        ]),
                        regularText(StrLibrary.privacyPolicy38),
                        regularText(StrLibrary.privacyPolicy39),
                        regularText(StrLibrary.privacyPolicy40),
                        // regularText(StrLibrary .privacyPolicy41),
                        // regularText(StrLibrary .privacyPolicy42),
                        // regularText(StrLibrary .privacyPolicy43),
                        // regularText(StrLibrary .privacyPolicy44),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy41_1),
                          regularTextSpan(StrLibrary.privacyPolicy41_2)
                        ]),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy42_1),
                          regularTextSpan(StrLibrary.privacyPolicy42_2)
                        ]),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy43_1),
                          regularTextSpan(StrLibrary.privacyPolicy43_2)
                        ]),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy44_1),
                          regularTextSpan(StrLibrary.privacyPolicy44_2)
                        ]),
                        regularText(StrLibrary.privacyPolicy45),
                        regularText(StrLibrary.privacyPolicy46),
                        regularText(StrLibrary.privacyPolicy47),
                        regularText(StrLibrary.privacyPolicy48),
                        regularText(StrLibrary.privacyPolicy49),
                        regularText(StrLibrary.privacyPolicy50),
                        regularText(StrLibrary.privacyPolicy51),
                        // regularText(StrLibrary .privacyPolicy52),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy52_1),
                          regularTextSpan(StrLibrary.privacyPolicy52_2)
                        ]),
                        boldText(StrLibrary.privacyPolicy53),
                        regularText(StrLibrary.privacyPolicy54),
                        regularText(StrLibrary.privacyPolicy55),
                        regularText(StrLibrary.privacyPolicy56),
                        regularText(StrLibrary.privacyPolicy57),
                        regularText(StrLibrary.privacyPolicy58),
                        boldText(StrLibrary.privacyPolicy59),
                        regularText(StrLibrary.privacyPolicy60),
                        regularText(StrLibrary.privacyPolicy61),
                        regularText(StrLibrary.privacyPolicy62),
                        regularText(StrLibrary.privacyPolicy63),
                        regularText(StrLibrary.privacyPolicy64),
                        regularText(StrLibrary.privacyPolicy65),
                        regularText(StrLibrary.privacyPolicy66),
                        regularText(StrLibrary.privacyPolicy67),
                        regularText(StrLibrary.privacyPolicy68),
                        regularText(StrLibrary.privacyPolicy69),
                        regularText(StrLibrary.privacyPolicy70),
                        regularText(StrLibrary.privacyPolicy71),
                        regularText(StrLibrary.privacyPolicy72),
                        boldText(StrLibrary.privacyPolicy73),
                        regularText(StrLibrary.privacyPolicy74),
                        // regularText(StrLibrary .privacyPolicy75),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy75_1),
                          regularTextSpan(StrLibrary.privacyPolicy75_2)
                        ]),
                        regularText(StrLibrary.privacyPolicy76),
                        regularText(StrLibrary.privacyPolicy77),
                        regularText(StrLibrary.privacyPolicy78),
                        regularText(StrLibrary.privacyPolicy79),
                        regularText(StrLibrary.privacyPolicy80),
                        regularText(StrLibrary.privacyPolicy81),
                        regularText(StrLibrary.privacyPolicy82),
                        regularText(StrLibrary.privacyPolicy83),
                        // regularText(StrLibrary .privacyPolicy84),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy84_1),
                          regularTextSpan(StrLibrary.privacyPolicy84_2)
                        ]),
                        regularText(StrLibrary.privacyPolicy85),
                        regularText(StrLibrary.privacyPolicy86),
                        regularText(StrLibrary.privacyPolicy87),
                        regularText(StrLibrary.privacyPolicy88),
                        regularText(StrLibrary.privacyPolicy89),
                        regularText(StrLibrary.privacyPolicy90),
                        regularText(StrLibrary.privacyPolicy91),
                        regularText(StrLibrary.privacyPolicy92),
                        regularText(StrLibrary.privacyPolicy93),
                        regularText(StrLibrary.privacyPolicy94),
                        // regularText(StrLibrary .privacyPolicy95),
                        richText([
                          boldTextSpan(StrLibrary.privacyPolicy95_1),
                          regularTextSpan(StrLibrary.privacyPolicy95_2)
                        ]),
                        boldText(StrLibrary.privacyPolicy96),
                        regularText(StrLibrary.privacyPolicy97),
                        boldText(StrLibrary.privacyPolicy98),
                        regularText(StrLibrary.privacyPolicy99),
                        regularText(StrLibrary.privacyPolicy100),
                        regularText(StrLibrary.privacyPolicy101),
                        boldText(StrLibrary.privacyPolicy102),
                        regularText(StrLibrary.privacyPolicy103),
                        regularText(StrLibrary.privacyPolicy104),
                        regularText(StrLibrary.privacyPolicy105),
                        regularText(StrLibrary.privacyPolicy106),
                        regularText(StrLibrary.privacyPolicy107),
                        boldText(StrLibrary.privacyPolicy108),
                        regularText(StrLibrary.privacyPolicy109),
                        boldText(StrLibrary.privacyPolicy110),
                        regularText(StrLibrary.privacyPolicy111),
                        boldText(StrLibrary.privacyPolicy112),
                        regularText(StrLibrary.privacyPolicy113),
                        boldText(StrLibrary.privacyPolicy114),
                        regularText(StrLibrary.privacyPolicy115),
                        boldText(StrLibrary.privacyPolicy116),
                        regularText(StrLibrary.privacyPolicy117),
                        regularText(StrLibrary.privacyPolicy118),
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

  TextSpan boldTextSpan(String text) =>
      TextSpan(text: text, style: Styles.ts_333333_13sp_medium);

  TextSpan regularTextSpan(String text) =>
      TextSpan(text: text, style: Styles.ts_333333_13sp);
}
