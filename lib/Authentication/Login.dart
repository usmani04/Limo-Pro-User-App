import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:limopro/Authentication/SignUp.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Extra/token.dart';
import '../Extra/videoplayer.dart';
import '../Menu.dart';
import 'forget.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _saveToken = false;
  bool _obscureText = true;
  String? tt;
  String? mail;
  String? error;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  submitData(String email,password) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/loginuser/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }));
    var data = jsonDecode(response.body.toString());
    tt =data['token'];
    mail=data['email'];
    print(tt);
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>Menu(mail:mail),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Login Success",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          )
      );
      await TokenHandler.saveToken(tt!);
      await TokenHandler.saveEmail(mail!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Login Failed",
                  style: TextStyle(color: Color(0xff37433c), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xfffbe0dd),
          )
      );

    }
  }
  RemoveData(String email,password) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/loginuser/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }));
    var data = jsonDecode(response.body.toString());
    tt =data['token'];
    mail=data['email'];
    error = data['error'];
    print(tt);
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>Menu(mail:mail),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Login Success",
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
                  "$error",
                  style: TextStyle(color: Color(0xff37433c), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xfffbe0dd),
          )
      );

    }
  }


  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
      return false;
    } else {
      // Permission denied
      return false;
    }
  }
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
      return false;
    } else {
      // Permission denied
      return false;
    }
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    requestNotificationPermission();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding:  EdgeInsets.all(28.0.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h,),
                Container(
                  width: 380.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF9f0202),
                      width: 4.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                      child: VideoWidget(), // Replace VideoWidget with your actual video widget
                    ),
                  ),
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
                SizedBox(height: 20.h),
                TextField(
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                  controller: pass,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
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
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: (){
                    Get.to(()=>First(),transition: Transition.leftToRight);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF9f0202), // Change this color to your desired border color
                          width: 2.0.w, // You can adjust the border width
                        ),
                        borderRadius: BorderRadius.circular(1.0), // You can adjust the border radius
                      ),
                      child: Checkbox(
                        activeColor: Color(0xFF9f0202),
                        value: _saveToken,
                        onChanged: (bool? value) {
                          setState(() {
                            _saveToken = value ?? false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Text(
                        'Remember',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        )
                    ),

                  ],
                ),
                SizedBox(height: 40.h),
      Container(
            decoration: BoxDecoration(
              color:Color(0xFF9f0202),
              borderRadius: BorderRadius.circular(10)
            ),
            child: ElevatedButton(
                    onPressed: () {
                      if(_saveToken){ submitData(email.text.trim(), pass.text.trim());}
                      else{
                        RemoveData(email.text.trim(), pass.text.trim());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.h),
                      primary: Color(0xFF9f0202),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
      ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: (){
                    Get.to(()=>SignUp(),transition: Transition.downToUp);
                  },
                  child: Text('DON\'T HAVE AN ACCOUNT',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Get.to(()=>SignUp(),transition: Transition.downToUp);
                  },
                  child: Text(' PLEASE SIGN UP',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
