/// CameraScreen.dart
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'Display.dart';

import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  const CameraScreen({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  late CameraController _cameraController;

  late Future<void> cameraValue;
  // late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.cameras.length == 0){
      print("no camera");
      return ;
    }
    _cameraController = CameraController(widget.cameras[0],ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    // _initializeControllerFuture = _co.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }


 


Future<String?> pickAndUploadFile() async {
    // loading = true;
    setState(() {});
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null) {
      File file = File(result.files.single.path!);
    
      setState(() {});

      return file.path; // Return the file path here
    }

    return null; // Return null if no file is selected
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        FutureBuilder(
            future: cameraValue,
            builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return CameraPreview(_cameraController);
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );

          }
        }
        )
      ],
      ),
    
      floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    FloatingActionButton(
      heroTag: 'btn1',
      onPressed: () async {
        try {
          await cameraValue;
          final image = await _cameraController.takePicture();
          if (!context.mounted) return;
          // Navigator.of(context).pop();
          // Navigator.pop(context);
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DisplayPictureScreen(
      imagePath: image.path,
    ),
    settings: RouteSettings(name: 'b'),
  ),
);
        } catch (e) {
          print(e);
        }
      },
      child: const Icon(Icons.camera_alt),
    ),
//     FloatingActionButton(
//       heroTag: 'btn2',
//       onPressed: () async {
//      String? selectedPath = await pickAndUploadFile();
// if (selectedPath != null) {
//   // Navigator.of(context).pop();
//   // Navigator.pop(context);
//   Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => DisplayPictureScreen(
//       imagePath: selectedPath,
//     ),
//     settings: RouteSettings(name: 'c'),
//   ),
// );
//     // File path is available, you can use it here
// } else {
//     // No file was selected
//     print("error");
// }
      
//       },
//       child: const Icon(Icons.add),
//     ),
  ],
),
    );
  }
}