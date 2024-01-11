import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Extra/videoplayer.dart';
import '../Menu.dart';
import 'Login.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  CountryCode? _selectedCode;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pno = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  String? error;
  String? playerId;
  @override
  void initState() {
    super.initState();
    myFunction();
  }
  Future<void> myFunction() async {
    playerId = await OneSignal.shared.getDeviceState().then((state) => state?.userId);
    print(playerId);
  }
  submitData(String name,email,pno,pass,cpass) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/usersignup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone_number": "+1${pno}",
          "password": pass,
          "confirm_password": cpass,
          "player_id": "$playerId"
        }));
    var data = jsonDecode(response.body.toString());
    print(data);
    error = data['error'];
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Account Created",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          )
      );
Get.to(()=>Login(),transition: Transition.upToDown);
print(playerId);
    } else {
      print(playerId);
      print('+1${pno}',);
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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Scaffold(
backgroundColor: Colors.black,
      body: Padding(
        padding:  EdgeInsets.all(28.0.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h),
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
                      child: Image.asset('images/tt.gif',fit: BoxFit.cover,)// Replace VideoWidget with your actual video widget
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                style: TextStyle(
                  color: Colors.white
                ),
                controller: name,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
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
                  hintText: 'Name',
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.white
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
              TextFormField(
                style: TextStyle(
                    color: Colors.white
                ),
                controller: pno,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor:Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        color: Color(0xFF9f0202), width: 4.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        color: Color(0xFF9f0202), width: 4.w),
                  ),
                  hintText: 'Enter phone number',
                  prefixIcon: CountryCodePicker(
                    initialSelection: 'US', // Set the initial selection to the country code 'US'
                    favorite: ['+1', 'US'],
                    enabled: false, // Disable user interaction with the widget
                    boxDecoration: BoxDecoration(color: Colors.white,),
                    textStyle: TextStyle(color: Colors.white),
                  )
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                style: TextStyle(
                    color: Colors.white
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
              SizedBox(height: 20.h),
              TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                controller: cpass,
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
                  hintText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                decoration: BoxDecoration(
                    color:Color(0xFF9f0202),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ElevatedButton(
                  onPressed: () {
                    submitData(name.text.trim(),email.text.trim(),pno.text.trim(),pass.text.trim(),cpass.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.h),
                    primary: Color(0xFF9f0202),
                  ),
                  child: Text(
                    'SIGNUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
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
