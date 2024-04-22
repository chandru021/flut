import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/camera/cameraScreen.dart';
import 'package:flutter_google_maps/camera/photoUpload.dart';
// import 'package:flutter_google_maps/animation.dart';
// import 'package:flutter_google_maps/summary.dart';
// import 'summary.dart';
import '../animation.dart';
import 'package:flutter_google_maps/map/location_service.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../camera/photoUpload.dart';
import '../animation.dart';




// void main() => runApp(MyApp());

double latitude = 0.0;
double longitude = 0.0;

class GMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.342423, 77.728165 ),
    // zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(11.342423, 77.728165 ));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  Future<Position> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

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


Future<Location> getAddressLocation(String address) async {
  print(address);
  
    
    List<Location> locations =
        await locationFromAddress(address);
    print("Address to Lat long ${locations.first.latitude} : ${locations.first.longitude}");

    return locations.first;
  
}



Future<void> sendCoordinates(double latitude, double longitude) async {
  final url = 'http://127.0.0.1:8000/test';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    },
  );

  if (response.statusCode == 200) {
    // Successful request
    print('Coordinates sent successfully');
    print(response.body[0]);
    // Map< String , dynamic > jsonResponse ;
    //  jsonDecode(response.body);
    // print(jsonResponse["message"]);
    print("indexing");
    // print(jsonResponse["urls"][0]);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LineByLineTextAnimation(data : jsonDecode(response.body))),
    );
  } else {
    // Request failed
    print('Failed to send coordinates. Status code: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Analyse'),
      // ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      decoration: InputDecoration(hintText: 'Search by address'),
                      onChanged: (value) {
                        // print(value);
                      },
                    ),
                  
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  
                  

                  if(_originController.text.isNotEmpty){
                    Location positions = await getAddressLocation(_originController.text);
                  _setMarker(LatLng(positions.latitude, positions.longitude));
                  _goToPlace(positions.latitude, positions.longitude);
                  latitude = positions.latitude;
                  longitude = positions.longitude;
                  
                  }
                  
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              myLocationButtonEnabled: false,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
  setState(() {
    _markers.clear(); // Clear existing markers
    _markers.add(
      Marker(
        markerId: MarkerId('marker'),
        position: point,
      ),
    );
  });
  print('Tapped location: ${point.latitude}, ${point.longitude}');
  latitude = point.latitude;
  longitude = point.longitude;
},


              
            ),

            
          ),
        ],
      ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      FloatingActionButton(
        onPressed: () async {
          Position positions = await getPosition();
          _setMarker(LatLng(positions.latitude, positions.longitude));
          _goToPlace(positions.latitude, positions.longitude);
          latitude = positions.latitude;
          longitude = positions.longitude;
        },
        child: Icon(Icons.my_location),
      ),
     FloatingActionButton.extended(
  heroTag: 'lightbulb_button',
  onPressed: () async {
    try {
      print("sending");
      print(latitude);
      print(longitude);
      sendCoordinates(latitude, longitude);
    } catch (e) {
      print("wrong");
    }
  },
  label: Text("Tell Me More !"),
), 
        ],
      ),
    ),
    );
  }

  Future<void> _goToPlace(

    double lat,
    double lng,
    

  ) async {
   

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    _setMarker(LatLng(lat, lng));
  }
}
