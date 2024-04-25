import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'Display.dart';
import 'camera.dart';
import 'package:http/http.dart' as http;

class photoUpload extends StatefulWidget {
  const photoUpload({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<photoUpload> {
  String? _imageUrl;
  late List<CameraDescription> cameras;
  bool loading = false;

  Future<void> _uploadImage(File pickedFile) async {
    print("hi");
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddv1dygfd/upload');
    print(url);

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'maill6ok'
      ..files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

    print(pickedFile.path);
    print(request);
    final response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      print(jsonMap['url']);
    } else {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      print(jsonMap);
    }
  }

  Future<String?> pickAndUploadFile(bool isFile) async {
    // loading = true;
    setState(() {});
     FilePickerResult? result;
    if(isFile == true){
    result = await FilePicker.platform.pickFiles();
    }else{
      result = await FilePicker.platform.pickFiles(type: FileType.image);
    }

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
    appBar: AppBar(title: const Text('Google Photos upload')),
    body: Center(
      child: loading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async{
                           WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    String temp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraApp(cameras: cameras),
        settings: RouteSettings(name: 'a'),
      ),
    );
                          },
                        ),
                        Text('Camera'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () async{

                          String? path = await pickAndUploadFile(true);

                          // _uploadImage(path);

                          if(path != null){

                          
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayPictureScreen(
                                        imagePath: path,
                                      ),
                                      settings: RouteSettings(name: 'c'),
                                    ),
                                  );
                          }
                          

                            // Add your functionality here
                          },
                        ),
                        Text('Files'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () async{
                            // Add your functionality here
                            String? path = await pickAndUploadFile(false);

                          // _uploadImage(path);

                          if(path != null){

                          
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayPictureScreen(
                                        imagePath: path,
                                      ),
                                      settings: RouteSettings(name: 'c'),
                                    ),
                                  );
                          }
                          },
                        ),
                        Text('Photos'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    ),
  );
}
}