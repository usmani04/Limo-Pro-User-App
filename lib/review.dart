import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'Menu.dart';

class Reviewnote extends StatefulWidget {
  final String? email;
  final String? dname;
  const Reviewnote({this.email,this.dname});

  @override
  State<Reviewnote> createState() => _ReviewnoteState();
}

class _ReviewnoteState extends State<Reviewnote> {
  TextEditingController _textEditingController = TextEditingController();
  double _rating = 3.0;

  void submitReview() async {
    String url = 'https://limo101.pythonanywhere.com/review/';

    // Create the request body
    Map<String, dynamic> requestBody = {
      "user_email": widget.email,
      "driver_name": widget.dname,
      "rating": _rating,
      "review":  _textEditingController.text,
    };

    // Create the request headers
    Map<String, String> headers = {
      "Content-Type": "application/json", // Adjust the content type as needed// Add your authorization header here
    };

    // Send the POST request
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers, // Set the headers
        body: jsonEncode(requestBody), // Encode the request body as JSON
      );

      if (response.statusCode == 200) {
        Get.to(()=>Menu(mail: widget.email),transition: Transition.circularReveal,duration: Duration(seconds: 1));
      } else {
        print(_textEditingController.text);
        print(_rating);
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred during the API request
      print('Error sending API request: $error');
    }
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ride Ended'),
          content: Text('Your ride has ended. Please submit your review before returning to the Menu screen'),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{
        _showDialog(context);
        return false;
      },
      child: Scaffold(
            body:Column(
              children: [
                Expanded(child: Container(
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
                  child:  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 35,),
                          Center(
                            child: Text(
                              'REVIEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            'Please give a review and rating',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color((0xFF9f0202)),width: 5) ),
                            child: TextField(
                              controller: _textEditingController,
                              maxLines: 8,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF9f0202),fontWeight: FontWeight.bold),
                                hintText: "Type a review....",
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                          SizedBox(height: 25),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Color(0xFF9f0202),width: 5),borderRadius: BorderRadius.circular(10)),
                              child: ElevatedButton(
                                onPressed: submitReview,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                                  primary: Colors.black,
                                ),
                                child: Text(
                                  'SUBMIT',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                )),
              ],
            )
          ),
    );


  }

}
