import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart%20';
import 'package:limopro/AboutUs.dart';
import 'package:limopro/booking/desttrack.dart';
import 'package:limopro/booking/tracking.dart';
import 'package:limopro/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Authentication/Login.dart';
import 'Cancelbooking.dart';
import 'GetHelp.dart';
import 'booking/prebooking form.dart';
import 'main.dart';
import 'msg.dart';
import 'notification.dart';
import 'travel history.dart';
class Menu extends StatefulWidget {
  final String? mail;
  const Menu({this.mail});

  @override
  State<Menu> createState() => _MenuState();
}
class _MenuState extends State<Menu> {
  void Dialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.info,
      headerAnimationLoop: true,
      title: 'GPS Tracking Not Available',
      desc:
      'GPS tracking is only available when your ride has been approved by the admin and the driver has started the journey. Please wait for their actions.\nThank you for choosing our service',
      btnOkText: 'OK',
      btnOkOnPress: () {
        // Do something when "YES" is clicked
      },
      btnOkColor: Color(0xFF207ac8),
      dismissOnTouchOutside: true,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }
  String? requestid;
  Future<void> removeTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.to(()=>Login(),transition: Transition.leftToRight);
  }
  List<Map<String, dynamic>> notifications = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    final apiUrl = "https://limo101.pythonanywhere.com/getnoti/";
    final requestBody = {"email": widget.mail};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error: $error");
    }
  }
  submitData() async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/gpstrackingcheck/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail,

        }));
    var data = jsonDecode(response.body.toString());
     requestid = data['request_id'];
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      print(widget.mail);

      if (data['ride_status'] == 'Customer is in car') {
        // Navigate to Tracking screen
        Get.to(() => destTracking(req: requestid), transition: Transition.rightToLeft);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff344439), size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Track Your Driver",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          ),
        );
      } else if (data['ride_status'] == 'Ride has been Started') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff344439), size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Track Your Driver",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          ),
        );
        Get.to(() => Tracking(req: requestid), transition: Transition.rightToLeft);
      } }else {
      Dialog(context);

    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  WillPopScope(
        onWillPop: () async {
          // Return false to prevent back navigation
          return false;
        },
      child: Scaffold(
        body: Column(children: [
Expanded(child: Container(
  decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft, // Start from the center-left
        end: Alignment.centerRight, // End at the center-right
        colors: [Color(0xFF9f0202), Colors.black], // Define your gradient colors
 // Adjust stops to position the second color in the center
      ),
  ),
  child: SingleChildScrollView(
      child: Column(
        children: [
//drawer header
//drawer body
GestureDetector(
  onTap: ()async{
      String url = "https://www.mobilephonescases.com";
      var urllaunchable = await canLaunchUrl(Uri.parse(url)); //canLaunch is from url_launcher package
      if(urllaunchable){
        await launchUrl(Uri.parse(url)); //launch is from url_launcher package to launch URL
      }else{
        print("URL can't be launched.");
      }
  },
  child:   Container(

      child: Image.asset("images/case.gif",fit: BoxFit.cover,),

  ),
),
          SizedBox(height: 20.h),
          Center(child: Text("LIMOUSINE SERVICES PRO",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp),)),
          SizedBox(height: 10.h),
          Center(child: Text("www.limoservicespro.com",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
          SizedBox(height: 10.h),
          Center(child: Text("1-800-835-7085",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
          SizedBox(height: 10.h),
          Center(child: Text("516-779-1862",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
          SizedBox(height: 30.h),
          GestureDetector(
              onTap: ()
              {

              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),

          GestureDetector(
              onTap: ()
              {
                Get.to(()=>AboutUsScreen(),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "About Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                Get.to(()=>ChatScreen(mail: widget.mail,),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Chat With Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                Get.to(()=>PreBook(mail: widget.mail,),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Schedule Car Service",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                submitData();
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "GPS Tracking",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
            onTap: () {
              // Navigate to NotificationScreen and set notifications to an empty list
              Get.to(() => NotificationScreen(mail: widget.mail,), transition: Transition.rightToLeft);
              setState(() {
                notifications = []; // Assuming 'notifications' is the list you want to update
              });
            },
            child: Padding(
              padding: EdgeInsets.all(18.0.sp),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 15.sp),
                      SizedBox(width: 30.w),
                      Text(
                        "Notification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Badge indicating new messages
                  if (notifications.isNotEmpty) // Show badge only if there are unread notifications
                    Positioned(
                      top: 0.0,
                      right: 140.0,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red, // Choose the color you want for the badge
                        ),
                        child: Text(
                          "${notifications.length}", // You can replace this with the actual count of new messages
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),


          GestureDetector(
              onTap: ()
              {
                Get.to(()=>TH(mail: widget.mail,),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Travel History",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                Get.to(()=>BookingCancel(),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Booking Cancellation",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                Get.to(()=>MyScreen(mail: widget.mail,),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                Get.to(()=>Help(mail: widget.mail,),transition: Transition.rightToLeft);
              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Get Help",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: ()
              {
                removeTokenFromSharedPreferences();

              },
              child: Padding(
                padding:  EdgeInsets.all(18.0.sp),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white,size: 15.sp),
                    SizedBox(width: 30.w),
                    Text(
                      "Exit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
  ),
))
        ],),
      ),
    );
  }
}
