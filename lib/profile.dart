import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Menu.dart';


class MyScreen extends StatefulWidget {
  final String? mail;

  const MyScreen({required this.mail});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool isEditable = false;
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();
  TextEditingController textFieldController3 = TextEditingController();
  String? fullName;
  String? phoneNumber;
  String? city;
  Uint8List? imageUrl;

  int? id;
  String? url;
  static Future<bool> requestgalleryPermission() async {
    final status = await Permission.photos.request();

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
  static Future<bool> requestcameraPermission() async {
    final status = await Permission.camera.request();

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
    fetchData();
    submitData();
    delayFetchImage();
    requestgalleryPermission();
    requestcameraPermission();
  }

  @override
  void dispose() {
    textFieldController1.dispose();
    textFieldController2.dispose();
    super.dispose();
  }

  Future<void> delayFetchImage() async {
    await Future.delayed(Duration(seconds: 1));
    fetchImage();
  }

  Future<void> submitData() async {
    var response = await http.post(
      Uri.https('limo101.pythonanywhere.com', '/userinfo/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.mail,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        url = '${data["picture"]}';
      });
      print('Success');
    } else {
      print(response.statusCode);
      print('Fail');
    }
  }

  Future<void> fetchImage() async {
    try {
      var response = await http.get(Uri.parse('https://limo101.pythonanywhere.com$url'));
      if (response.statusCode == 200) {
        setState(() {
          imageUrl = response.bodyBytes;
        });
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  Future<void> fetchData() async {
    var response = await http.post(
      Uri.parse('https://limo101.pythonanywhere.com/userinfo/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.mail,
      }),
    );

    if (response.statusCode == 200) {
      print(url);
      print(phoneNumber);
      var data = jsonDecode(response.body);
      url = data['picture'];
      setState(() {
        fullName = data["name"];
        phoneNumber = data["phone_number"];
        id = data["id"];
        textFieldController1.text = fullName ?? '';
        textFieldController2.text = phoneNumber ?? '';
        url = data["picture"]; // Corrected key name
      });
      // Fetch image after setting the URL
      fetchImage();
    }
  }

  void toggleEditability() {
    setState(() {
      isEditable = !isEditable;
    });
  }
  final String imageUr =
      'https://example.com/your_image.jpg';
  PickedFile? image;

  Future<void> _showImagePickerDialog() async {
    final picker = ImagePicker();
    final pickedImage = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child:  ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await picker.getImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        image = pickedImage;
                      });
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await picker.getImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {
                        image = pickedImage;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedImage != null) {
      final pickedFile = await picker.getImage(source: pickedImage);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          image = pickedFile;
        });
        print('Selected Image: ${pickedFile.path}');
      }
    }
  }

  Future<void> updateData() async {
    final url = Uri.parse('https://limo101.pythonanywhere.com/upusde/');
    final request = http.MultipartRequest('POST', url);

    // Add the image file to the request if it is not null
    if (image != null) {
      final imageFile = await http.MultipartFile.fromPath('profilepic', image!.path);
      request.files.add(imageFile);
    }
    // Add other form fields to the request
    request.fields.addAll({
      'user_id': id.toString(),
      'name': textFieldController1.text,
      'phone_number': textFieldController2.text,
    });

    // Send the request and get the response
    final response = await request.send();

    if (response.statusCode == 200) {
      Get.to(()=>Menu(mail: widget.mail,),transition: Transition.leftToRight);
      print(image);
      final responseData = await response.stream.bytesToString();

      // Parse the response data if it is JSON
      final jsonData = jsonDecode(responseData);

      // Access the selected image link from the response
      final selectedImageLink = jsonData['profilepic'];

      print(selectedImageLink);
      print('Data updated successfully');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h,),
                  GestureDetector(
                    onTap: () {
                      if (isEditable) {
                        _showImagePickerDialog();
                      }
                    },
                    child: Center(
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundImage: image != null
                            ? FileImage(File(image!.path)) as ImageProvider<Object>?
                            : (imageUrl != null ? MemoryImage(imageUrl!) as ImageProvider<Object>? : null),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
                    child: GestureDetector(
                      onTap: toggleEditability,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            isEditable ? 'Disable Editing' : 'Enable Editing',
                            style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.w),
                          Icon(Icons.edit, color: Colors.white, size: 22.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 320.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF9f0202),
                        width: 3.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2.w,
                          blurRadius: 5.w,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: textFieldController1,
                      enabled: isEditable,
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
                          BorderSide(color: Color(0xFF2eff00), width: 4.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Color(0xFF2eff00), width: 4.w),
                        ),
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 320.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:Color(0xFF9f0202),
                        width: 3.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2.w,
                          blurRadius: 5.w,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: textFieldController2,
                      enabled: isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color:  Colors.white,),
                        filled: true,
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Color(0xFF2eff00), width: 4.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Color(0xFF2eff00), width: 4.w),
                        ),
                        hintText: 'Phone No',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
                        textStyle: TextStyle(fontSize: 20.sp),
                      ),
                      child: Text('Save',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
