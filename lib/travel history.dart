import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



class TravelHistory {
  final String driverName;
  final String driverProfilePic;
  final String driverEmail;
  final String currentLocation;
  final String destinationLocation;
  final String price;
  final DateTime timestamp;

  TravelHistory({
    required this.driverName,
    required this.driverProfilePic,
    required this.driverEmail,
    required this.currentLocation,
    required this.destinationLocation,
    required this.price,
    required this.timestamp,
  });

  factory TravelHistory.fromJson(Map<String, dynamic> json) {
    return TravelHistory(
      driverName: json['driver_name'],
      driverProfilePic: json['driver_profilepic'],
      driverEmail: json['driver_email'],
      currentLocation: json['current_location'],
      destinationLocation: json['destination_location'],
      price: json['price'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class TH extends StatefulWidget {
  final String? mail;
  const TH({this.mail});

  @override
  State<TH> createState() => _THState();
}

class _THState extends State<TH> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [    Color(0xFF9f0202),
              Colors.black,], // Adjust the colors as needed
            begin: Alignment.centerLeft, // Start from the center-left
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Text(
                'TRAVEL HISTORY',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<TravelHistory>>(
              future: fetchTravelHistory(widget.mail??''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.white,));
                } else if (snapshot.hasError) {
                  return Center(child: Text('No travel history available.',style: TextStyle(color: Colors.white),));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No travel history available.',style: TextStyle(color: Colors.white),),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final travel = snapshot.data![index];
                        return Padding(
                          padding:  EdgeInsets.all(8.0.w),
                          child: Container(
                            margin: EdgeInsets.all(5.0.w),
                            padding: EdgeInsets.all(22.0.w),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(

                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40.r,
                                    backgroundColor: Color(0xFF190000),
                                    backgroundImage: NetworkImage('https://limo101.pythonanywhere.com/'+travel.driverProfilePic),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text('Driver Name:',style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                                      Text(travel.driverName,style: TextStyle(color: Colors.white,fontSize: 30.sp)),

                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 20.h),
                                child:   Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Text('Pick-Up Location',style: TextStyle(color: Colors.white,fontSize: 12.sp),),

                                    Text('${travel.currentLocation}',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                                    SizedBox(height: 20.h,),
                                    Text('Drop-Off Location: ',style: TextStyle(color: Colors.white,fontSize: 12.sp),),

                                    Text('${travel.destinationLocation}',style: TextStyle(color: Colors.white,fontSize: 16.sp)),
                                    SizedBox(height: 0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('\$${travel.price}',style: TextStyle(color: Colors.white,fontSize: 35.sp,fontWeight: FontWeight.bold),),
                                      ],),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${DateFormat('yyyy-MM-dd').format(travel.timestamp)}',style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                                        Text(' ${DateFormat('HH:mm:ss').format(travel.timestamp)}',style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                                      ],)
                                  ],),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );

  }

  Future<List<TravelHistory>> fetchTravelHistory(String email) async {
    final response = await http.post(
      Uri.parse('https://limo101.pythonanywhere.com/userth/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body)['travelling_history'];
      return rawList.map((json) => TravelHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load travel history');
    }
  }
}

