import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'cameraScreen.dart';

class CameraApp extends StatelessWidget {

  const CameraApp({required this.cameras, Key? key}) : super(key: key);

  final List<CameraDescription> cameras;

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: CameraScreen(cameras: cameras),
    );
  }
}