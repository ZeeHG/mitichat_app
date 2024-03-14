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
        title: StrLibrary.userAgreement,
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
                      boldText(StrLibrary.userAgreement1),
                      regularText(StrLibrary.userAgreement2),
                      boldText(StrLibrary.userAgreement3),
                      regularText(StrLibrary.userAgreement4),
                      boldText(StrLibrary.userAgreement5),
                      regularText(StrLibrary.userAgreement6),
                      boldText(StrLibrary.userAgreement7),
                      boldText(StrLibrary.userAgreement8),
                      regularText(StrLibrary.userAgreement9),
                      regularText(StrLibrary.userAgreement10),
                      regularText(StrLibrary.userAgreement11),
                      regularText(StrLibrary.userAgreement12),
                      regularText(StrLibrary.userAgreement13),
                      boldText(StrLibrary.userAgreement14),
                      regularText(StrLibrary.userAgreement15),
                      regularText(StrLibrary.userAgreement16),
                      regularText(StrLibrary.userAgreement17),
                      regularText(StrLibrary.userAgreement18),
                      boldText(StrLibrary.userAgreement19),
                      regularText(StrLibrary.userAgreement20),
                      regularText(StrLibrary.userAgreement21),
                      regularText(StrLibrary.userAgreement22),
                      regularText(StrLibrary.userAgreement23),
                      regularText(StrLibrary.userAgreement24),
                      regularText(StrLibrary.userAgreement25),
                      regularText(StrLibrary.userAgreement26),
                      regularText(StrLibrary.userAgreement27),
                      regularText(StrLibrary.userAgreement28),
                      regularText(StrLibrary.userAgreement29),
                      regularText(StrLibrary.userAgreement30),
                      regularText(StrLibrary.userAgreement31),
                      boldText(StrLibrary.userAgreement32),
                      regularText(StrLibrary.userAgreement33),
                      regularText(StrLibrary.userAgreement34),
                      regularText(StrLibrary.userAgreement35),
                      regularText(StrLibrary.userAgreement36),
                      regularText(StrLibrary.userAgreement37),
                      regularText(StrLibrary.userAgreement38),
                      boldText(StrLibrary.userAgreement39),
                      regularText(StrLibrary.userAgreement40),
                      regularText(StrLibrary.userAgreement41),
                      regularText(StrLibrary.userAgreement42),
                      regularText(StrLibrary.userAgreement43),
                      regularText(StrLibrary.userAgreement44),
                      regularText(StrLibrary.userAgreement45),
                      boldText(StrLibrary.userAgreement46),
                      regularText(StrLibrary.userAgreement47),
                      regularText(StrLibrary.userAgreement48),
                      regularText(StrLibrary.userAgreement49),
                      regularText(StrLibrary.userAgreement50),
                      boldText(StrLibrary.userAgreement51),
                      regularText(StrLibrary.userAgreement52),
                      regularText(StrLibrary.userAgreement53),
                      regularText(StrLibrary.userAgreement54),
                    ],
                  )))),
    );
  }

  Container boldText(String text) => Container(
        margin: EdgeInsets.only(bottom: 13.h),
        child: text.toText..style = Styles.ts_333333_13sp_medium,
      );

  Container regularText(String text) => Container(
        margin: EdgeInsets.only(bottom: 13.h),
        child: text.toText..style = Styles.ts_333333_13sp,
      );
}
