import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  final String? mail;
  const NotificationScreen({this.mail});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          isLoading = false;
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
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
   width: 1500.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [    Color(0xFF9f0202),
              Colors.black,], // Adjust the colors as needed
              begin: Alignment.centerLeft, // Start from the center-left
              end: Alignment.topCenter,
          ),
        ),
        child:  Column(
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Text(
                'NOTIFICATIONS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            isLoading
                ? CircularProgressIndicator(
              color: Colors.white,
            )
                : notifications.isNotEmpty? Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final DateTime timestamp = DateTime.parse(notifications[index]['timestamp']);
                  final String formattedDate = "${timestamp.day}-${timestamp.month}-${timestamp.year}";
                  return Padding(
                    padding:  EdgeInsets.all(8.0.w),
                    child: Container(
                      margin: EdgeInsets.all(8.0.w),
                      padding: EdgeInsets.all(8.0.w),
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
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                Text(formattedDate,style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                              ],),
                            ),
                            Row(
                              children: [
                                Icon(Icons.notifications,color:Colors.white ,),
                                SizedBox(width: 5.w,),
                                Text(
                                  notifications[index]['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding:  EdgeInsets.all(8.0.w),
                          child: Wrap(children:[
                            Text(notifications[index]['body'],style: TextStyle(color: Colors.white),)]),
                        ),

                      ),
                    ),
                  );
                },
              ),
            )   : Text(
              'No Notification Available',
              style: TextStyle(fontSize: 18.sp),
            ),
       ]
        ),
      ),
    );
  }


}