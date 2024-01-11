import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import 'Login.dart';
class New extends StatefulWidget {
  final String? vp;
  const New({this.vp});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  TextEditingController pass =TextEditingController();
  TextEditingController cpass =TextEditingController();
  Data(String pass,cpass) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/fpuser/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.vp,
          "new_password": pass,
          "confirm_password": cpass
        }));
    var data = jsonDecode(response.body.toString());

    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>Login(),transition: Transition.downToUp);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Password Updated",
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
                  "Updating Failed",
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
        padding:  EdgeInsets.all(28.0.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h,),
              Text(
                  "Create New Password",
                  style:TextStyle(
                    letterSpacing: 2,
                    fontSize: 18,
                    color:
                    Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 20.h),
              TextField(
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
                controller: pass,

                decoration: InputDecoration(

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
              SizedBox(height: 20.h),
              TextField(
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
                controller: cpass,

                decoration: InputDecoration(
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
                  hintText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color:Color(0xFF9f0202),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Data(pass.text.trim(),cpass.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 100.w, vertical: 15.h),
                      primary: Color(0xFF9f0202),
                    ),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
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
