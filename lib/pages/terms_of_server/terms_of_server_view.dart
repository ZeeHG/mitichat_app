import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'terms_of_server_logic.dart';

class TermsOfServerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.userAgreement,
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
                      boldText(StrRes.userAgreement1),
                      regularText(StrRes.userAgreement2),
                      boldText(StrRes.userAgreement3),
                      regularText(StrRes.userAgreement4),
                      boldText(StrRes.userAgreement5),
                      regularText(StrRes.userAgreement6),
                      boldText(StrRes.userAgreement7),
                      boldText(StrRes.userAgreement8),
                      regularText(StrRes.userAgreement9),
                      regularText(StrRes.userAgreement10),
                      regularText(StrRes.userAgreement11),
                      regularText(StrRes.userAgreement12),
                      regularText(StrRes.userAgreement13),
                      boldText(StrRes.userAgreement14),
                      regularText(StrRes.userAgreement15),
                      regularText(StrRes.userAgreement16),
                      regularText(StrRes.userAgreement17),
                      regularText(StrRes.userAgreement18),
                      boldText(StrRes.userAgreement19),
                      regularText(StrRes.userAgreement20),
                      regularText(StrRes.userAgreement21),
                      regularText(StrRes.userAgreement22),
                      regularText(StrRes.userAgreement23),
                      regularText(StrRes.userAgreement24),
                      regularText(StrRes.userAgreement25),
                      regularText(StrRes.userAgreement26),
                      regularText(StrRes.userAgreement27),
                      regularText(StrRes.userAgreement28),
                      regularText(StrRes.userAgreement29),
                      regularText(StrRes.userAgreement30),
                      regularText(StrRes.userAgreement31),
                      boldText(StrRes.userAgreement32),
                      regularText(StrRes.userAgreement33),
                      regularText(StrRes.userAgreement34),
                      regularText(StrRes.userAgreement35),
                      regularText(StrRes.userAgreement36),
                      regularText(StrRes.userAgreement37),
                      regularText(StrRes.userAgreement38),
                      boldText(StrRes.userAgreement39),
                      regularText(StrRes.userAgreement40),
                      regularText(StrRes.userAgreement41),
                      regularText(StrRes.userAgreement42),
                      regularText(StrRes.userAgreement43),
                      regularText(StrRes.userAgreement44),
                      regularText(StrRes.userAgreement45),
                      boldText(StrRes.userAgreement46),
                      regularText(StrRes.userAgreement47),
                      regularText(StrRes.userAgreement48),
                      regularText(StrRes.userAgreement49),
                      regularText(StrRes.userAgreement50),
                      boldText(StrRes.userAgreement51),
                      regularText(StrRes.userAgreement52),
                      regularText(StrRes.userAgreement53),
                      regularText(StrRes.userAgreement54),
                    ],
                  )))),
    );
  }

  Container boldText(String text) => Container(
    margin: EdgeInsets.only(bottom: 13.h),
    child: text.toText..style=Styles.ts_333333_13sp_medium,
  );

  Container regularText(String text) => Container(
    margin: EdgeInsets.only(bottom: 13.h),
    child: text.toText..style=Styles.ts_333333_13sp,
  );
}
