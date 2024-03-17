import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:flutter_module/ui/camera_view.dart';
import 'package:flutter_module/ui/box_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreen createState() => _CameraScreen();
}


class _CameraScreen extends State<CameraScreen> {
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<CameraViewState> CameraViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: SizeUtils.width,
          height: double.infinity,
          decoration: AppDecoration.fillBlueGray,
          child: SingleChildScrollView(
            child: Container(
              decoration: AppDecoration.outlineBlack,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.h,
                  vertical: 15.v,
                ),
                decoration: AppDecoration.fillBlueGray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 480.v,
                      width: 395.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // show when cam run
                          // show when no cam
                          CameraView(resultsCallback, key: CameraViewKey),
                          boundingBoxes2(results),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 494.v,
                              width: 395.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray8009e,
                                borderRadius: BorderRadius.circular(
                                  18.h,
                                ),
                                border: Border.all(
                                  color: appTheme.lightGreenA700,
                                  width: 5.h,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 6.v),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "learn more about your pet",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    SizedBox(height: 40.v),
                    Padding(
                      padding: EdgeInsets.only(left: 68.h),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgGallery,
                            height: 39.v,
                            width: 38.h,
                            margin: EdgeInsets.symmetric(vertical: 21.v),
                            onTap: () {
                              onTapImgGalleryone(context);
                            },
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSlatBtn1,
                            height: 81.adaptSize,
                            width: 81.adaptSize,
                            margin: EdgeInsets.only(left: 57.h),
                            onTap: () async {
                              CameraViewKey.currentState?.pauseCamera();
                            },
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.rotage,
                            height: 39.v,
                            width: 38.h,
                            margin: EdgeInsets.only(left: 50.h),
                            onTap: () async {
                              CameraViewKey.currentState?.switchCamera();
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 7.v),
                    Padding(
                      padding: EdgeInsets.only(left: 23.h),
                      child: CustomIconButton(
                        height: 34.v,
                        width: 38.h,
                        padding: EdgeInsets.all(3.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgArrowDown,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  void resultsCallback(
      List<ResultObjectDetection> results, Duration inferenceTime) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.results = results;
      objectDetectionInferenceTime = inferenceTime;
      for (var element in results) {
        print({
          "rect": {
            "left": element.rect.left,
            "top": element.rect.top,
            "width": element.rect.width,
            "height": element.rect.height,
            "right": element.rect.right,
            "bottom": element.rect.bottom,
          },
        });
      }
    });
  }


  /// Navigates to the uploadScreen when the action is triggered.
  onTapImgGalleryone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.uploadScreen);
  }
}
