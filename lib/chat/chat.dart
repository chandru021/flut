import 'dart:convert';
  //  import 'package:record/record.dart';

import 'package:camera/camera.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_maps/camera/photoUpload.dart';
import 'package:geolocator/geolocator.dart';

import '../camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
// import 'package:cloudinary_sdk/cloudinary_sdk.dart' as cloudinary;


// void main() {
//   runApp(const MyApp());
// }

class ChatBot extends StatelessWidget {
  // const ChatBotUI({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBotUI(),
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
        title: const Text('Hi !'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
          height: 50, // Set the height to 50 (adjust as needed)
          decoration: BoxDecoration(
            color: Colors.grey[300],  // Set the background color to grey
            borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ), // Add rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
        child: Text(
          "Hey what would you like to do ?",
          style: TextStyle(
            color: Colors.black, // Set the text color to black
            fontSize: 16, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
            ),
          ),
        ),
                      
                      ElevatedButton(
                        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
            ),
           
          ),
                      onPressed: () => {
                            setState(() {
                              isButton1Pressed = true;
                              isButton2Pressed = false;
                            })
                          },
                      child: Text("Add Complaint")),
                  ElevatedButton(
                    style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
            ),
           
          ),
                    onPressed: () => {
                    setState(() {
                              isButton2Pressed = true;
                              isButton1Pressed = false;
                            })
                  }, child: Text("Check Status")),
        
                    ],
                  )
                  ,
                  
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




// final record = AudioRecorder();

// Check and request permission if needed







  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
  children: [
    // Expanded( // Add Expanded widget here
      Expanded(
        child: Container(
          // width: 200, // Remove fixed width
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Complaint',
            ),
            controller: widget.textController,
            enabled: isTextFieldEnabled,
          ),
        // ),
            ),
      ),
    SizedBox(width: 5),
    IconButton(
      onPressed: () async {
        String complaintText = widget.textController.text;
        if (complaintText.isNotEmpty) {
          Position positions = await getPosition();
          className = await sendComplaintToBackend(complaintText, positions.latitude, positions.longitude);
          setState(() {
            isButton3Pressed = true;
            isTextFieldEnabled = false;
          });
        }
      },
      icon: Icon(Icons.send),
    ),
    SizedBox(width: 5),
    IconButton(
      icon: Icon(Icons.mic),
      onPressed: () => {},
    ),
  ],
),
        SizedBox(height: 10),
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
    
    // WidgetsFlutterBinding.ensureInitialized();
    // List<CameraDescription> cameras = await availableCameras();
    // String temp = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CameraApp(cameras: cameras),
    //     settings: RouteSettings(name: 'a'),
    //   ),
    // );
    String? temp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => photoUpload(),
        settings: RouteSettings(name: 'a'),
      ),
    );

    if(temp == null)
      return "";
    return temp;
  }

  @override
  Widget build(BuildContext context) {
String className = widget.className;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
  width: double.infinity,
  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
  // height: 50, // Set the height to 50 (adjust as needed)
  decoration: BoxDecoration(
    color: Colors.grey[300],  // Set the background color to grey
    borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ), // Add rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        "This complaint will be forwarded to $className department",
        style: TextStyle(
          color: Colors.black, // Set the text color to black
          fontSize: 16, // Set the font size
          fontWeight: FontWeight.bold, // Set the font weight
        ),
      ),
    ),
  ),
),
SizedBox(height: 10),
      Container(
  width: double.infinity,
  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
  // height: 50, // Set the height to 50 (adjust as needed)
  decoration: BoxDecoration(
    color: Colors.grey[300],  // Set the background color to grey
    borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ), // Add rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        "Do you want to upload additional files ?",
        style: TextStyle(
          color: Colors.black, // Set the text color to black
          fontSize: 16, // Set the font size
          fontWeight: FontWeight.bold, // Set the font weight
        ),
      ),
    ),
  ),
),
      // Text("This complaint will be forwarded $className"),
      
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
    ),
   
  ),
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
          ElevatedButton(
            style: ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
    ),
   
  ),
            onPressed: () {
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
  bool showReply = false;
  List<dynamic> curStatus = [];

  Widget createChildren(BuildContext context) {
  return Column(
    children: curStatus.map((status) => Column(
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,)
      ],
    )
    ).toList(),
  );
}

// Call this function where you want to display the status widgets



  Future<List<dynamic>> getStatus(String complaintId) async {
  var url = 'http://127.0.0.1:8000/getStatus';
  var response = await http.post(Uri.parse(url), body: {'complaintId': complaintId});

  if (response.statusCode == 200) {
    // Request successful, handle response here
    dynamic a = jsonDecode(response.body);
    // print(a["message"][0]);

    List<dynamic> convertedList = a['message'].map((item) => '${item.values.last} on ${item.values.first}').toList();
    // return a['message'];
    if(a['officer'] == "")
      convertedList.add("Officer not yet assigned");
    else{
      String officer = a['officer'];
      convertedList.add("Handling Officer $officer");
    }
    return convertedList;
  } else {

    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
  children: [
    // Expanded( // Add Expanded widget here
      Expanded(
        child: Container(
          // width: 200, // Remove fixed width
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Complaint',
            ),
            controller: widget.textController,
            // enabled: isTextFieldEnabled,
          ),
        // ),
            ),
      ),
    SizedBox(width: 5),
    IconButton(
      onPressed: () async {
        String complaintText = widget.textController.text;
        if (complaintText.isNotEmpty) {
          // Position positions = await getPosition();
          List<dynamic> resp = await getStatus(complaintText);
          // print(resp);
          // className = await sendComplaintToBackend(complaintText, positions.latitude, positions.longitude);
          if(resp.length != 0){

          setState(() {
            showReply = true;
            curStatus = resp;
            // isButton3Pressed = true;
            // isTextFieldEnabled = false;
          });
          }
        }
      },
      icon: Icon(Icons.send),
    ),
    SizedBox(width: 5),
    
  ],
),
        SizedBox(height: 20),
        if(showReply == true) createChildren(context)
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
  late String tUrl = "";
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

  Future<String> sendFinal(String complaintText , String className , String file, double latitude, double longitude, int anonymous , int share) async {
  var url = 'http://127.0.0.1:8000/register';
    DateTime now = DateTime.now();
String formattedDate = '${now.year}-${now.month}-${now.day}';
// print(formattedDate);
  var response = await http.post(Uri.parse(url), body: {'complaint': complaintText , 'dept' : className, 'url' : file,'userId':'1','share': share.toString(),'anonymous':anonymous.toString(), 'latitude':latitude.toString(), 'longitude' : longitude.toString(), 'regDate' : formattedDate});
  // var response = await http.post(Uri.parse(url), body: {'complaint': complaintText , 'dept' : className, 'url' : file,'userId':'1','share':'1','anonymous':'0', 'latitude':latitude.toString(), 'longitude' : longitude.toString(), 'status': 'registered'});

  if (response.statusCode == 200) {
    // Request successful, handle response here
    dynamic a = jsonDecode(response.body);
    
    return a['message'];
  } else {
    // Request failed, handle error here
    return "";
  }
}


Future<bool> deleteFromCloud(String urlToDel) async {
    // return;
    print("hola");
    print(urlToDel);
    final cloudinary = Cloudinary.full(
    apiUrl: 'https://api.cloudinary.com/v1_1', 
    apiKey: "438944912241122",
     apiSecret: "GAKiDSvKDENNdr9bR7Y0QZ9H3t0",
      cloudName: "ddv1dygfd"
      );

  final response = await cloudinary.deleteResource(
      url: urlToDel,
      resourceType: CloudinaryResourceType.image,
      invalidate: false,
    );
    if(response.isSuccessful ?? false){
      //Do something else
      return true;
    }
    return false;
  }

  @override
  void initState(){
    super.initState();
    tUrl = widget.url;
  }
  // bool checkbox1Value 
  bool checkbox1Value = false;
  bool checkbox2Value = false;
  @override
  Widget build(BuildContext context) {
    // tUrl = widget.url;
    return Column(
      children: [


        if (tUrl != "none") 
  Container(
    child: Row(
      children: [
        ElevatedButton(
  onPressed: () async{
    // Add functionality here

    bool res = await deleteFromCloud(tUrl);
    if(res){
    setState(() {
      tUrl = "none";
    });
    }
  },
  child: Icon(Icons.close),
),// Add the X icon here
        Text(widget.url.split('/').last), // Display the URL
      ],
    ),
  )
        ,
        Row(
          children: [
            Checkbox(
              value: checkbox1Value,
              onChanged: (value) {
                setState(() {
                  checkbox1Value = value!;
                });
              },
            ),
Text("Make your Complaint Anonymous")
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: checkbox2Value,
              onChanged: (value) {
                setState(() {
                  checkbox2Value = value!;
                });
              },
            ),
Text("Share your complaints with other users")
          ],
        ),
        
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

      
            ElevatedButton(
              style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
   
              ),
              onPressed: () async{
                Position positions = await getPosition();

                int ano = checkbox1Value ? 1 : 0;
                int sha = checkbox2Value ? 1 : 0;
                String temp = await sendFinal(widget.complaint, widget.dept, widget.url, positions.latitude, positions.longitude, ano , sha);
                setState(() {
                            uniqueId = temp;
                           
                  });
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
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Your Complaint has been registerd"),
            Container(
              // mainAxisAlignment : MainAxisAlignment.start,
  width: double.infinity,
  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
  // height: 50, // Set the height to 50 (adjust as needed)
  decoration: BoxDecoration(
    color: Colors.grey[300],  // Set the background color to grey
    borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ), // Add rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Your Complaint has been registerd",
        style: TextStyle(
          color: Colors.black, // Set the text color to black
          fontSize: 16, // Set the font size
          fontWeight: FontWeight.bold, // Set the font weight
        ),
      ),
    ),
  ),
),
SizedBox(height: 10,),
            // Text("Your Complaint Id is"),
            Container(
  width: double.infinity,
  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
  // height: 50, // Set the height to 50 (adjust as needed)
  decoration: BoxDecoration(
    color: Colors.grey[300],  // Set the background color to grey
    borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ), // Add rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Your Complaint Id is",
        style: TextStyle(
          color: Colors.black, // Set the text color to black
          fontSize: 16, // Set the font size
          fontWeight: FontWeight.bold, // Set the font weight
        ),
      ),
    ),
  ),
),
SizedBox(height: 10,),
            Row(
              children: [

                Container(
  width: double.infinity,
  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
  // height: 50, // Set the height to 50 (adjust as needed)
  decoration: BoxDecoration(
    color: Colors.grey[300],  // Set the background color to grey
    borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ), // Add rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: 
    
    Row(children: [

      Text(uniqueId),
                IconButton(
                      icon: Icon(Icons.content_copy),
                        onPressed: () async{
                              // 
                         
                  await Clipboard.setData(ClipboardData(text: uniqueId));
                  // copied successfully
                },
                        // child: Text("your complaint id is $uniqueId"),
                          
                
                ),
    ],)

  ),
),
                
              ],
            ),
            
          ],
        );
        

      
        // if (isButton3Pressed) Button3Body(),
      
    
  }
}


