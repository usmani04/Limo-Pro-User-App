import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../extra/videoplayer.dart';
import '../menu.dart';
import 'Login.dart';
import 'otp.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool _saveToken = false;
  bool _obscureText = true;
  String? tt;
  String? ve;
  TextEditingController email = TextEditingController();
Data(String email) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/verifyemail/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));
    var data = jsonDecode(response.body.toString());
    tt =data['otp'];
    ve =data['verified_email'];
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>otp(op:tt,vp:ve),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "OTP Send",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Unregistered Email",
                  style: TextStyle(color: Color(0xff37433c), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xfffbe0dd),
          )
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:  EdgeInsets.all(28.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Center(
                child: Text(
                    "Email Verification",
                    style:TextStyle(
                      letterSpacing: 2,
                      fontSize: 28.sp,
                      color:
                      Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
              SizedBox(height: 45.h),
              Text(
                  "Kindly provide your registered email address,OTP will be sent to your email",
                  style:TextStyle(
                    fontSize: 16.sp,
                    color:
                    Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 40.h),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color:  Colors.white,),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                    BorderSide(color: Color(0xFF9f0202), width: 4.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                    BorderSide(color: Color(0xFF9f0202), width: 4.w),
                  ),
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 60.h),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color:Color(0xFF9f0202),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Data(email.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.h),
                      primary: Color(0xFF9f0202),
                    ),
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

