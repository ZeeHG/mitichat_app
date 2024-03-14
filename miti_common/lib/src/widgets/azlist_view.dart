import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class WrapAzListView<T extends ISuspensionBean> extends StatelessWidget {
  const WrapAzListView(
      {Key? key,
      // this.itemScrollController,
      required this.data,
      required this.itemCount,
      required this.itemBuilder,
      this.firstTagPaddingColor})
      : super(key: key);

  /// Controller for jumping or scrolling to an item.
  // final ItemScrollController? itemScrollController;
  final List<T> data;
  final int itemCount;
  final Widget Function(BuildContext context, T data, int index) itemBuilder;
  final firstTagPaddingColor;

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: data,
      // physics: AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        var model = data[index];
        return itemBuilder(context, model, index);
      },
      // itemScrollController: itemScrollController,
      susItemBuilder: (BuildContext context, int index) {
        var model = data[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return _buildTagView(
            model.getSuspensionTag(), index == 0 ? firstTagPaddingColor : null);
      },
      susItemHeight: 0,
      indexBarData: SuspensionUtil.getTagIndexList(data),
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        textStyle: Styles.ts_999999_11sp,
        selectTextStyle: Styles.ts_FFFFFF_11sp,
        selectItemDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Styles.c_8443F8,
        ),
        indexHintWidth: 96,
        indexHintHeight: 97,
        indexHintDecoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageRes.indexBarBg, package: 'miti_common'),
            fit: BoxFit.contain,
          ),
        ),
        indexHintAlignment: Alignment.centerRight,
        indexHintTextStyle: Styles.ts_333333_20sp_semibold,
        indexHintOffset: const Offset(-30, 0),
      ),
    );
  }

  Widget _buildTagView(String tag, Color? color) => Container(
        color: color ?? Styles.c_F7F8FA,
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 0),
              alignment: Alignment.centerLeft,
              width: 1.sw,
              color: Styles.c_FFFFFF,
              child: tag.toText..style = Styles.ts_999999_16sp,
            )
          ],
        ),
      );
}
