import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);
  final double value;
  final Function(dynamic value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesLibrary.c_FFFFFF,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Column(
        children: [
          _buildIndicatorLabel(),
          SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 1,
              inactiveTrackHeight: 1,
              activeTrackColor: StylesLibrary.c_999999_opacity30,
              inactiveTrackColor: StylesLibrary.c_999999_opacity30,
              activeTickColor: StylesLibrary.c_999999_opacity30,
              inactiveTickColor: StylesLibrary.c_999999_opacity30,
              activeMinorTickColor: StylesLibrary.c_999999_opacity30,
              inactiveMinorTickColor: StylesLibrary.c_999999_opacity30,
              thumbColor: StylesLibrary.c_FFFFFF,
              tickOffset: Offset(0, -10.h),
              // labelOffset: Offset(0, -45.h),
            ),
            child: SfSlider(
              min: 0,
              max: 2,
              value: value,
              interval: 1,
              showTicks: true,
              showLabels: false,
              labelFormatterCallback: (actualValue, formattedText) {
                return '打';
              },
              // enableTooltip: false,
              minorTicksPerInterval: 1,
              labelPlacement: LabelPlacement.onTicks,
              edgeLabelPlacement: EdgeLabelPlacement.inside,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorLabel() => Stack(
        children: [
          StrLibrary.little.toText
            ..style = StylesLibrary.ts_333333_12sp
            ..onTap = () => onChanged?.call(.0),
          Align(
            alignment: Alignment.center,
            child: StrLibrary.standard.toText
              ..style = StylesLibrary.ts_333333_17sp
              ..onTap = () => onChanged?.call(1.0),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: StrLibrary.big.toText
              ..style = StylesLibrary.ts_333333_20sp
              ..onTap = () => onChanged?.call(2.0),
          ),
        ],
      );
}
