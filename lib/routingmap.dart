import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'Extra/Assistant.dart';
import 'Extra/Dailog.dart';
import 'Extra/globol.dart';
import 'Extra/handler.dart';
import 'locationsearching/currentloc.dart';
import 'locationsearching/destloc.dart';
class route extends StatefulWidget {
  const route({super.key});

  @override
  State<route> createState() => _routeState();
}

class _routeState extends State<route> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  List<LatLng> pLineCoOrdinatesList = [];
  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);


  }
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    checkIfLocationPermissionAllowed();
  }
  Future<void> drawPolyLineFromOriginToDestination() async
  {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = await LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = await LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if(decodedPolyLinePointsResultList.isNotEmpty)
    {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng)
      {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Color(0xFF9f0202),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }
  Future<void> _loadMarkerIcons() async {
    _driverIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/fort.png',
    );
  }
  BitmapDescriptor? _driverIcon;
  LocationPermission? _locationPermission;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locateUserPosition();
            },
          ),
          Positioned(
            top: 80,
            left: 45,
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> www()));
                    },
                    child: Container(
                      height: 55,
                      width: 330,
                      decoration:
                      BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFF9f0202),
                          width: 5,
                        ),),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 50,
                            color: Color(0xFF9f0202),
                            child: const Icon(Icons.location_on_outlined, color: Colors.white,),
                          ),
                          const SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,7) + "..."
                                    : "not getting address",
                                style: const TextStyle(color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),


                    ),
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () async
                    {

                      var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                      if(responseFromSearchScreen == "obtainedDropoff")
                      {

                        await drawPolyLineFromOriginToDestination();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: 330,
                      decoration:
                      BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFF9f0202),
                          width: 5,
                        ),),

                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 50,
                            color: Color(0xFF9f0202),
                            child: const Icon(Icons.location_on_outlined, color: Colors.white,),
                          ),
                          const SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "To",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userDropOffLocation != null
                                    ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                    : "Where to go?",
                                style: const TextStyle(color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

              ),


            ),
          ),



          //ui for searching location
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.w, vertical: 15.h),
                        primary: Color(0xFF9f0202)),
                    onPressed: () {
                      Navigator.pop(context);
//                       showModalBottomSheet(
//                           context: context,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(25.0),
//                             ),
//                           ),
//                           builder: (context) {
//                             return SizedBox(
//                               height: 300,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
// // children: [
// //   ElevatedButton(
// //     style: ElevatedButton.styleFrom(
// //         primary: Colors.grey),
// //     onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (c)=> booking())); },
// //     child: Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         child: Container(
// //           child: Row(children: [
// //            Padding(
// //              padding: const EdgeInsets.all(8.0),
// //              child: Image.asset("images/eee.png",width: 95,height: 55),
// //            ),
// //             SizedBox(width: 20),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text('ECONOMY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// //                 Text('\$5 /km Capacity: 3, Type:Economic Sedan\n(1min)')
// //               ],
// //             ),
// //
// //           ],)
// //         ),
// //       ),
// //     ),
// //   ),
// //   Padding(
// //     padding: const EdgeInsets.all(8.0),
// //     child: Container(
// //         child: Row(children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Image.asset("images/eee.png",width: 95,height: 55),
// //           ),
// //           SizedBox(width: 20),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('COMFORT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// //               Text('\$8 /km Capacity: 4, Type:SUV\n(Unavailable)')
// //             ],
// //           ),
// //
// //         ],)
// //     ),
// //   ),
// //   Padding(
// //     padding: const EdgeInsets.all(8.0),
// //     child: Container(
// //         child: Row(children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Image.asset("images/eee.png",width: 95,height: 55),
// //           ),
// //           SizedBox(width: 20),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('EXCLUSIVE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// //               Text('\$10 /km Capacity: 8, Type:Limousine\n(Unavailable)')
// //             ],
// //           ),
// //
// //         ],)
// //     ),
// //   ),
// //
// // ],
//                               ),
//                             );
//                           });

                    },

                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 24,color: Colors.white),
                    ),

                  ),
                  // ElevatedButton(
                  //   child: const Text(
                  //     "GPS ROUTES",
                  //   ),
                  //   onPressed: ()
                  //   {
                  //     drawPolyLineFromOriginToDestination();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Colors.green,
                  //       minimumSize: Size.fromHeight(40),
                  //       textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
