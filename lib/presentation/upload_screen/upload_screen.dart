import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key})
      : super(
          key: key,
        );

  @override
  _UploadScreen createState() => _UploadScreen();
}

class _UploadScreen extends State<UploadScreen> {
  late ModelObjectDetection _objectPetModelYoloV8;
  late ModelObjectDetection _objectModel;
  String? textToShow;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    String pathObjectDetectionPetModelYolov8 =
        "assets/models/yolov8n-pet.torchscript";
    try {
      _objectPetModelYoloV8 = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionPetModelYolov8, 37, 640, 640,
          labelPath: "assets/labels/labels_objectDetection_pet.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future runObjectDetectionPetYoloV8() async {
    //pick a random image

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Stopwatch stopwatch = Stopwatch()..start();

    objDetect = await _objectPetModelYoloV8.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);
    textToShow = inferenceTimeAsString(stopwatch);

    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: SizeUtils.width,
          height: double.infinity,
          decoration: AppDecoration.fillBlueGray,
          child: SingleChildScrollView(
            child: Container(
              child: Container(
                decoration: AppDecoration.fillBlueGray,
                child: Column(
                  children: [
                    Container(
                      decoration: AppDecoration.outlineBlack900,
                      child: Text(
                        "upload your image",
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: 25.v),
                    Text(
                      "Browse and choose an image to search pet’s breed",
                      style: theme.textTheme.bodyLarge,
                    ),
                    Container(
                      decoration: AppDecoration.outlineLightGreenA.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder18,
                      ),
                      height: 450,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: objDetect.isNotEmpty
                                ? _image == null
                                ? const Text('No image selected.')
                                : _objectPetModelYoloV8.renderBoxesOnImage(_image!, objDetect)
                                : _image == null
                                ? const Text('No image selected.')
                                : Image.file(_image!),
                          ),
                          // Container(
                          //   child: objDetect.isNotEmpty
                          //       ? _image == null
                          //           ? Container(
                          //               padding: const EdgeInsets.symmetric(
                          //                 horizontal: 150,
                          //                 vertical: 180,
                          //               ),
                          //               child: Text('No image selected.'),
                          //             )
                          //           : Expanded(
                          //               child: _objectModel.renderBoxesOnImage(
                          //                   _image!, objDetect),
                          //             )
                          //       : _image == null
                          //           ? Container(
                          //               margin: const EdgeInsets.symmetric(
                          //                   horizontal: 5),
                          //               padding: const EdgeInsets.symmetric(
                          //                 horizontal: 150,
                          //                 vertical: 180,
                          //               ),
                          //               child: Text('No image selected.'),
                          //             )
                          //           : Image.file(_image!),
                          //   // : Container(
                          //   //     margin: const EdgeInsets.symmetric(
                          //   //         horizontal: 5),
                          //   //     padding: const EdgeInsets.symmetric(
                          //   //       horizontal: 150,
                          //   //       vertical: 180,
                          //   //     ),
                          //   //     child: Text('detected.'),
                          //   //   )
                          // ),
                          // SizedBox(height: 20.v),
                          // Text(
                          //   "Image Preview",
                          //   style: theme.textTheme.displayMedium,
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 39.v),
                    CustomIconButton(
                      onTap: runObjectDetectionPetYoloV8,
                      height: 63.adaptSize,
                      width: 63.adaptSize,
                      padding: EdgeInsets.all(15.h),
                      decoration: IconButtonStyleHelper.fillBlackTL31,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgPlus,
                      ),
                    ),
                    SizedBox(height: 20.v),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 410.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.fromLTRB(18.h, 10.v, 354.h, 11.v),
        onTap: () {
          onTapArrowdownone(context);
        },
      ),
    );
  }

  /// Navigates to the cameraScreen when the action is triggered.
  onTapArrowdownone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cameraScreen);
  }
}
