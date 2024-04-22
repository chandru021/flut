import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'camera.dart';
// import 'package:http/http.dart';
import 'package:http/http.dart' as http;
// import './services/photos_services.dart';
class photoUpload extends StatefulWidget {
  const photoUpload({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<photoUpload> {
String? _imageUrl ;
  

 late List<CameraDescription> cameras;

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
    // setState(() {
    //   final url = jsonMap['url'];
    //   print(url);
    //   _imageUrl = url;
    // });
  }else{
     final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonMap = jsonDecode(responseString);
    print(jsonMap);

  }
}


  bool loading = false;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Photos upload')),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : TextButton(
          // onPressed: () => pickAndUploadFile(),
          onPressed: () async{
            // pickAndUploadFile();
            // WidgetsFlutterBinding.ensureInitialized();
            // cameras =await availableCameras();

            WidgetsFlutterBinding.ensureInitialized();
            cameras = await availableCameras();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraApp(cameras : cameras),
                settings: RouteSettings(name: 'a'),),

              );
          },
          child: const Text('Upload Image'),
        ),
      ),
    );
  }
}