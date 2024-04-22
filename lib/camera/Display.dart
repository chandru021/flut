import 'dart:convert';
import 'dart:io';
// import 'dart:js';
import 'package:flutter_google_maps/map/Map.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';


// import 'flutter'

class MyParameter {
  final String value;

  MyParameter(this.value);
}


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  Future<String> _uploadImage(String pickedFile) async {

  final url = Uri.parse('https://api.cloudinary.com/v1_1/ddv1dygfd/upload');
  print(url);
  
  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'maill6ok'
    ..files.add(await http.MultipartFile.fromPath('file', pickedFile));


  // print(pickedFile.path);
  print(request);
  final response = await request.send();



  print(response.statusCode);
  if (response.statusCode == 200) {
    
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonMap = jsonDecode(responseString);
    // print(jsonMap['url']);
    return jsonMap['url'];
    // Navigator.of(context).pop();
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

  return "";
}


  const DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    print(imagePath);
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: 

       Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      FloatingActionButton(
          heroTag: 'ok_button',
        onPressed: () async {
          // print("ok");
        String url = await _uploadImage(imagePath);

        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.push(context , GMap());
        // Navigator.popUntil(context, ModalRoute.withName('/'));
        // Navigator.of(context, rootNavigator: true);
        // onPressed: () {
//  Navigator.pushNamed(context,'/a');
// },


        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.of(context).pop();
        // Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.popUntil(context, (route) => route.isFirst, result: MyParameter('example'));
        Navigator.pop(context , url);
        Navigator.pop(context , url);
        // Navigator.of(context).popUntil(ModalRoute.withName('/'));
//         int count = 0;
// Navigator.of(context).popUntil((_) => count++ >= 2);
          
        },
        child: Icon(Icons.my_location),
      ),
     FloatingActionButton.extended(
  heroTag: 'retake_button',
  onPressed: () {
  // Navigator.of(context).pop();
  Navigator.pop(context);
  
  // Navigator.popUntil(context, (route) => route.isFirst);
  
  
},
  label: Text("Retake"),
), 
        ],
      ),
    ),
    );
  }
}