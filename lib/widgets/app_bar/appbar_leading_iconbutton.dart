import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_icon_button.dart'; // ignore: must_be_immutable
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AppbarLeadingIconbutton extends StatelessWidget {
  AppbarLeadingIconbutton({Key? key, this.imagePath, this.margin, this.onTap})
      : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        decoration: AppDecoration.fillBlueGray,
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 34.v,
          width: 38.h,
          child: CustomImageView(
            imagePath: ImageConstant.imgArrowDown,
          ),
        ),
      ),
    );
  }
}
