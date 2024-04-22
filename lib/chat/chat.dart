import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../camera/camera.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

class ChatBot extends StatelessWidget {
  // const ChatBotUI({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatBotUI(),
    );
  }
}

class ChatBotUI extends StatefulWidget {
  // const MyPage({super.key});

  @override
  State<ChatBotUI> createState() => _MyPageState();
}

class _MyPageState extends State<ChatBotUI> {
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;

  TextEditingController textController1 = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => {
                          setState(() {
                            isButton1Pressed = true;
                            isButton2Pressed = false;
                          })
                        },
                    child: Text("Add Complaint")),
                ElevatedButton(onPressed: () => {
                  setState(() {
                            isButton2Pressed = true;
                            isButton1Pressed = false;
                          })
                }, child: Text("Check Status")),
              ],
            ),
            SizedBox(height: 20),
            if (isButton1Pressed)
              Button1Body(
                textController: textController1,
              ),
              if (isButton2Pressed)
              Button2Body(
                
              ),
          ],
        ),
      ),
    );
  }
}

class Button1Body extends StatefulWidget {
  Button1Body({required this.textController});
  //  bool isTextFieldEnabled = true;
  // bool isButton3Pressed = false; 

  TextEditingController textController ;

  @override
  State<Button1Body> createState() => _Button1BodyState();
}

class _Button1BodyState extends State<Button1Body> {

Future<Position> getPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  
  return await Geolocator.getCurrentPosition();
}

Future<String> sendComplaintToBackend(String complaintText, double latitude, double longitude) async {
  var url = 'http://127.0.0.1:8000/classify';
  var response = await http.post(Uri.parse(url), body: {'complaint': complaintText , 'latitude' : latitude.toString(), 'longitude' : longitude.toString() });

  if (response.statusCode == 200) {
    // Request successful, handle response here
    dynamic a = jsonDecode(response.body);
    
    return a['message'];
  } else {
    // Request failed, handle error here
    return "";
  }
}

  bool isTextFieldEnabled = true; // Add this variable
   bool isButton3Pressed = false; 
   String className = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Complaint',
                ),
                controller: widget.textController,
                enabled: isTextFieldEnabled, // Set the enabled property
              ),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              onPressed: () async{
                String complaintText = widget.textController.text;
                if (complaintText.isNotEmpty) {
                  Position positions = await getPosition();
                  className = await sendComplaintToBackend(complaintText,positions.latitude,positions.longitude);
                  // print(className);
                  setState(() {
                    // className : cN;
                    isButton3Pressed = true;
                    isTextFieldEnabled = false; // Disable the text field
                  });

                }
              },
              child: Text("Ok"),
            ),
            SizedBox(width: 5),
            ElevatedButton(onPressed: () => {}, child: Text("Audio")),
          ],
        ),
        SizedBox(height: 20),
        if (isButton3Pressed) Button3Body(complaintText: widget.textController.text, 
        className : className),
      ],
    );
  }
}

class Button3Body extends StatefulWidget {
  // const Button3Body({super.key});
  final String complaintText;
  final String className;

  Button3Body({required this.complaintText, required this.className});

  @override
  State<Button3Body> createState() => _Button3BodyState();
}

class _Button3BodyState extends State<Button3Body> {

  bool isButton6Pressed = false;
  bool isButton7Pressed = false;

    String fileUrl = "";
  Future<String> initializeCameraAndNavigate() async {
    
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    String temp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraApp(cameras: cameras),
        settings: RouteSettings(name: 'a'),
      ),
    );
    return temp;
  }

  @override
  Widget build(BuildContext context) {
String className = widget.className;
    return Column(children: [
      Text("This complaint will be forwarded $className"),
      Text("Do you want to upload file?"),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: ()async{

             
            fileUrl = await initializeCameraAndNavigate();
            print("this is from origitn");
            print(fileUrl);
             setState(() {
                isButton6Pressed = true;
                isButton7Pressed = false;
              });

            }
            ,
            child: Text("Yes"),
          ),
          SizedBox(width: 20),
          ElevatedButton(onPressed: () {
            setState(() {
                isButton6Pressed = false;
                isButton7Pressed = true;
              });
          }, child: Text("NO")),
        ],
      ),
      if (isButton6Pressed) Button4Body(url: fileUrl,complaint:widget.complaintText ,dept:className ,),
      if (isButton7Pressed) Button4Body(url : "none", complaint:widget.complaintText ,dept:className ,),
    ]);
  }
}


class Button2Body extends StatefulWidget {
  // Declaration
  TextEditingController textController = TextEditingController();

  @override
  State<Button2Body> createState() => _Button2BodyState();
}

class _Button2BodyState extends State<Button2Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Complaint ID',
                ),
                controller: widget.textController,
              ),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              onPressed: () {
                String complaintID = widget.textController.text; // Get the text from the text box
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => NextPage(complaintID: complaintID),
                //   ),
                // );
                print(complaintID);
              },
              child: Text("Ok"),
            ),
            SizedBox(width: 5),
            ElevatedButton(onPressed: () => {}, child: Text("Audio")),
          ],
        ),
        SizedBox(height: 20),
        // if (isButton3Pressed) Button3Body(),
      ],
    );
  }
}

class Button4Body extends StatefulWidget {
  final String url ;
  final String complaint;
  final String dept; 
  // Declaration
  TextEditingController textController = TextEditingController();
  Button4Body({required this.url, required this.complaint, required this.dept});

  @override
  State<Button4Body> createState() => _Button4BodyState();
}

class _Button4BodyState extends State<Button4Body> {

  String uniqueId = "";
  Future<Position> getPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  
  return await Geolocator.getCurrentPosition();
}

  Future<String> sendFinal(String complaintText , String className , String file, double latitude, double longitude) async {
  var url = 'http://127.0.0.1:8000/register';
  var response = await http.post(Uri.parse(url), body: {'complaint': complaintText , 'dept' : className, 'url' : file,'userId':'1','share':'1','anonymous':'0', 'latitude':latitude.toString(), 'longitude' : longitude.toString(), 'status': 'registered'});

  if (response.statusCode == 200) {
    // Request successful, handle response here
    dynamic a = jsonDecode(response.body);
    
    return a['message'];
  } else {
    // Request failed, handle error here
    return "";
  }
}



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
          
            ElevatedButton(
              onPressed: () async{
                Position positions = await getPosition();

                uniqueId = await sendFinal(widget.complaint, widget.dept, widget.url, positions.latitude, positions.longitude);
                // print("hm/);
                // print();
                // String complaintID = widget.textController.text; // Get the text from the text box
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => NextPage(complaintID: complaintID),
                //   ),
                // );
                // print(complaintID);
              },
              child: Text("Submit complaint"),
            ),
             // Create and return the widget you want to display
            
            
          ],
          
        ),
        SizedBox(height: 20),

      if (uniqueId.isNotEmpty) DisplayWidget(id: uniqueId,),
        // if (isButton3Pressed) Button3Body(),
      ],
    );
  }
}




class DisplayWidget extends StatefulWidget {
  // final String url ;
  // final String complaint;
  final String id; 
  // Declaration
  // TextEditingController textController = TextEditingController();
  DisplayWidget({required this.id});

  @override
  State<DisplayWidget> createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {

  // String id = 



  @override
  Widget build(BuildContext context) {
    String uniqueId = widget.id;
    return Column(

          children: [
          
            Text("your complaint id is $uniqueId"),
            
            
          ],
        );
        

      
        // if (isButton3Pressed) Button3Body(),
      
    
  }
}


