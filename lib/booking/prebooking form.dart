import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:custom_alert_dialog_box/custom_alert_dialog_box.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../Extra/handler.dart';
import '../Menu.dart';
import '../locationsearching/currentloc.dart';
import '../locationsearching/destloc.dart';
import '../routingmap.dart';

class PreBook extends StatefulWidget {
  final String? mail;
  const PreBook({this.mail});

  @override
  State<PreBook> createState() => _PreBookState();
}

class _PreBookState extends State<PreBook> {
  String currentAddress = "Current Location";
  double? lat;
  double? long;

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    print(lat);
    print(long);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Data();
    print(widget.mail);
  }
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        _getLocation();

        fullAddress += placemark.name ?? '';
        fullAddress += (placemark.name != null && placemark.subThoroughfare != null) ? ', ' : '';
        fullAddress += placemark.subThoroughfare ?? '';
        fullAddress += (placemark.subThoroughfare != null && placemark.thoroughfare != null) ? ', ' : '';
        fullAddress += placemark.thoroughfare ?? '';
        fullAddress += (placemark.thoroughfare != null && placemark.subLocality != null) ? ', ' : '';
        fullAddress += placemark.subLocality ?? '';
        fullAddress += (placemark.subLocality != null && placemark.locality != null) ? ', ' : '';
        fullAddress += placemark.locality ?? '';
        fullAddress += (placemark.locality != null && placemark.administrativeArea != null) ? ', ' : '';
        fullAddress += placemark.administrativeArea ?? '';
        fullAddress += (placemark.administrativeArea != null && placemark.postalCode != null) ? ', ' : '';
        fullAddress += placemark.postalCode ?? '';
        fullAddress += (placemark.postalCode != null && placemark.country != null) ? ', ' : '';
        fullAddress += placemark.country ?? '';
print(fullAddress);
        setState(() {
          currentAddress = fullAddress;
        });
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error, display an error message to the user, or retry the operation.
    }
  }

  String fullAddress = '';

  String? selectedServiceType;
  String? selectedServiceTyp;

  TextEditingController dateInput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  final List<String> items = [
    'Economy Car',
    'SUV Car',
    'Luxury Car',
  ];
  final List<String> item = [
    'Airport',
    'Wedding',
    'Parties',
    'Restaurent',
    'Other'
  ];
  String? selectedValue;
  TextEditingController name = TextEditingController();
  TextEditingController pno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController cmnt = TextEditingController();
  void showCustomDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success, // Change this to the desired dialog type
      animType: AnimType.bottomSlide,
      title: 'REQUEST SUBMIT',
      desc: 'Your request has been received. We\'ll email your bill and notify you upon its completion. Please check your email or app for our prompt response.',
      headerAnimationLoop: true,
      btnOkOnPress: () {
        Get.to(() => Menu(mail: widget.mail), transition: Transition.leftToRight, duration: Duration(seconds: 1));
      },
      btnOkText: 'OK',
      btnOkColor: Color(0xFF00ca71),
      dismissOnTouchOutside: false,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }


  void Dialog(BuildContext context) {
    AwesomeDialog(
      headerAnimationLoop: true,
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Another Booking Request?',
      desc: 'Your previous request is still pending. Want to make another reservation now?',
      btnOkOnPress: () {
        Get.to(() => Menu(mail: widget.mail),
            transition: Transition.leftToRight,
            duration: Duration(seconds: 1));
    },

      btnCancelOnPress: () {


      },
      btnCancelColor: Color(0xFF0098ff),
      btnOkColor: Color(0xFF0098ff),
      dismissOnTouchOutside: false,
      barrierColor: Colors.black.withOpacity(0.9),
      btnOkText: 'NO',
      btnCancelText: 'YES',
    )
      ..show();
  }
  Data() async {
    var response = await post(
      Uri.https('limo101.pythonanywhere.com', '/checkbooking/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.mail,
      }),
    );
    var data = jsonDecode(response.body.toString());
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);

    if (response.statusCode == 200) {
      if (data["message"] == "Proceed to booking") {
      } else {
        Dialog(context);
      }
    }
  }

  submitData(String name,pno,email,date,time,cmnt,) async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
   String? current = originPosition!=null ? originPosition!.locationName : fullAddress;
   var latc =  originPosition!=null ? originPosition!.locationLatitude.toString() : lat;
   var longc = originPosition!=null ? originPosition!.locationLongitude.toString() : long;
   var response = await post(Uri.https('limo101.pythonanywhere.com', '/createbooking/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail,
          "name": name,
          "service_type": selectedValue,
          "vehicle_type": selectedServiceType,
          "phone_number": pno,
          "billing_email": email,
          "payment_mode": selectedServiceTyp,
          "current_location": current,
          "current_coordinates": {
            "current_lat":  latc,
            "current_long":  longc
          },
          "destination_location": destinationLocation!.locationName,
          "destination_coordinates": {
            "dest_lat":  destinationLocation!.locationLatitude.toString(),
            "dest_long": destinationLocation!.locationLongitude.toString(),
          },
          "date": date,
          "time":time,
          "comment": cmnt
        }));
    var data = jsonDecode(response.body.toString());
    print(data);
    String? dd = data['request_id'];
    print(dd);

    print(response.statusCode);

    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      if (data["message"] == "Booking created successfully") {
        showCustomDialog(context);
      }} else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Booking Failed",
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft, // Start from the center-left
                end: Alignment.topCenter, // End at the center-right
                colors: [
                  Color(0xFF9f0202),
                  Colors.black,
                ], // Define your gradient colors
                // Adjust stops to position the second color in the center
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      String url = "https://www.mybesttechgifts.com";
                      var urllaunchable = await canLaunchUrl(Uri.parse(
                          url)); //canLaunch is from url_launcher package
                      if (urllaunchable) {
                        await launchUrl(Uri.parse(
                            url)); //launch is from url_launcher package to launch URL
                      } else {
                        print("URL can't be launched.");
                      }
                    },
                    child: Container(
                      child: Image.asset(
                        "images/rr.gif",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding:  EdgeInsets.all(28.0.sp),
                    child: Column(
                      children: [
                        Text(
                          'PRE BOOKING FORM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Please fill the form for the complete the booking procedure',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 355.w,
                          height: 55.h,
                          child: TextField(
                            controller: name,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0xFF9f0202),
                              ),
                              hintStyle: TextStyle(color: Color(0xFF9f0202)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              hintText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              height: 50.h,
                              width: 145.w,
                              child: InputDecorator(
                                decoration: dropdownInputDecoration,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Service Type',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Color(0xFF9f0202),
                                      ),
                                    ),
                                    items: item
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style:  TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Color(0xFF9f0202)),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    buttonStyleData:  ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16.w),
                                      height: 40.h,
                                      width: 140.w,
                                    ),
                                    menuItemStyleData:  MenuItemStyleData(
                                      height: 40.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Container(
                              height: 50.h,
                              width: 145.w,
                              child: InputDecorator(
                                decoration: dropdownInputDecoration,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Vehicle Type',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Color(0xFF9f0202),
                                      ),
                                    ),
                                    items: items
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style:  TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Color(0xFF9f0202)),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedServiceType,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedServiceType = value;
                                      });
                                    },
                                    buttonStyleData:  ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16.w),
                                      height: 40.h,
                                      width: 140.w,
                                    ),
                                    menuItemStyleData:  MenuItemStyleData(
                                      height: 40.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: 345.w,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: pno,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.call,
                                color: Color(0xFF9f0202),
                              ),
                              hintStyle: TextStyle(color: Color(0xFF9f0202)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              hintText: 'Phone no',
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: 345.w,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFF9f0202),
                              ),
                              hintStyle: TextStyle(color: Color(0xFF9f0202)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.sp),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.sp),
                              ),
                              hintText: 'Billing Email Address',
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: 345.w,
                          height: 50.h,
                          child: DropdownButtonFormField<String?>(
                            value: selectedServiceTyp, // Set the selected value

                            onChanged: (String? newValue) {
                              setState(() {
                                selectedServiceTyp =
                                    newValue; // Update the selected value
                              });
                            },

                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color(0xFF9f0202)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              hintText: 'Payment Mode',
                              prefixIcon: Icon(
                                Icons.payments, // Replace with the desired icon

                                color: Color(0xFF9f0202),
                              ),
                            ),

                            items: [
                              'Pay by PayPal',
                              'Pay by Credit Card',
                              'Pay by Zelle',
                            ] // Replace with your list of options

                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Color(0xFF9f0202),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> route()));
                          },
                          child: Container(
                            width: 345.w,
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFF9f0202), width: 6.w),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.w),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF9f0202),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      Provider.of<AppInfo>(context).userPickUpLocation != null
                                          ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                                          :    currentAddress?? 'Current Location',


                                      style: TextStyle(
                                        color: Color(0xFF9f0202),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (c)=> route()));
                            },
                            child: Container(
                              width: 345.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xFF9f0202), width: 6.h),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Color(0xFF9f0202),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        Provider.of<AppInfo>(context).userDropOffLocation != null
                                            ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                            : "Destination Location",
                                        style: TextStyle(
                                          color: Color(0xFF9f0202),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )

                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Container(
                              width: 145.w,
                              child: TextFormField(
                                style: TextStyle(
                                  color: Color(
                                      0xFF9f0202), // Set the text color to the desired color
                                ),
                                decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: Color(0xFF9f0202)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6.w),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6.w),
                                  ),
                                  hintText: 'Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today, // Calendar icon

                                    color: Color(0xFF9f0202),
                                  ),
                                ),
                                readOnly: true,
                                controller: dateInput,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),

                                      //DateTime.now() - not to allow to choose before today.

                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);

                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16

                                    setState(() {
                                      dateInput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Container(
                              width: 145.w,
                              child: TextFormField(
                                style: TextStyle(
                                  color: Color(
                                      0xFF9f0202), // Set the text color to the desired color
                                ),
                                decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: Color(0xFF9f0202)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6.w),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6.w),
                                  ),
                                  hintText: 'Time',
                                  prefixIcon: Icon(
                                    Icons.timelapse_outlined, // Calendar icon

                                    color: Color(0xFF9f0202),
                                  ),
                                ),
                                readOnly: true,
                                controller: timeinput,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    String formattedTime =
                                        pickedTime.format(context);

                                    setState(() {
                                      timeinput.text = formattedTime;
                                    });
                                  } else {
                                    print("Time is not selected");
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width:345.w,
                          child: TextField(
                            controller: cmnt,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.comment,
                                color: Color(0xFF9f0202),
                              ),
                              hintStyle: TextStyle(color: Color(0xFF9f0202)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Color(0xFF9f0202), width: 6.w),
                              ),
                              hintText: 'Comment',
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: 345.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF9f0202),
                                width: 4.w,
                              ),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          child: ElevatedButton(
                            onPressed: () {
                              submitData(name.text.trim(),pno.text.trim(),email.text.trim(),dateInput.text.trim(),timeinput.text.trim(),cmnt.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80.w, vertical: 15.h),
                              primary: Colors.black,
                            ),
                            child: Text(
                              'REQUEST RIDE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

final InputDecoration dropdownInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Color(0xFF9f0202)),
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFF9f0202), width: 6),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFF9f0202), width: 6),
  ),
  hintText: 'Vehicle Type',
);
