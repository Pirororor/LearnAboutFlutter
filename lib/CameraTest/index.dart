import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:test_flutter/Sidebar/index.dart';

import 'widgets/DisplayPictureScreen.dart';
import 'widgets/TakeCameraScreen.dart';

class CameraTest extends StatelessWidget {
  const CameraTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CameraTestInner();
  }
}

class CameraTestInner extends StatefulWidget {
  const CameraTestInner({Key? key}) : super(key: key);

  @override
  State<CameraTestInner> createState() => _CameraTestInnerState();
}

class _CameraTestInnerState extends State<CameraTestInner> {
  List<CameraDescription>? cameras;
  bool isLoaded = false;
  XFile? image;

  @override
  void initState() {
    super.initState();
    localInit();
  }

  void localInit() async {
    final cameras = await availableCameras();
    setValues(cameras: cameras, isLoaded: true);
  }

  void setValues({cameras, isLoaded}) {
    setState(() {
      this.cameras = cameras;
      this.isLoaded = isLoaded;
    });
  }

  void onBackFromPictureDisplayScreen() {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Camera Test"),
        ),
        drawer: const Sidebar(),
        body: isLoaded
            ? (() {
                final path = image?.path;
                if (path != null) {
                  return DisplayPictureScreen(
                    imagePath: path,
                    onBack: () {
                      onBackFromPictureDisplayScreen();
                    },
                    onSave: (imagePath) {
                      GallerySaver.saveImage(imagePath);
                      Fluttertoast.showToast(
                          msg: "Image saved to your phone's gallery!");
                      onBackFromPictureDisplayScreen();
                    },
                  );
                } else {
                  return TakePictureScreen(
                    camera: cameras!.first,
                    onTakeImage: (image) => setState(() {
                      this.image = image;
                    }),
                  );
                }
              })()
            : const Center(child: Text('Loading')));
  }
}
