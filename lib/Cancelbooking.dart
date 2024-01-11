import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
class BookingCancel extends StatefulWidget {
  const BookingCancel({super.key});

  @override
  State<BookingCancel> createState() => _BookingCancelState();
}

class _BookingCancelState extends State<BookingCancel> {
  Future<void> _launchCaller() async {
    final uri = Uri.parse('tel:+15165145169');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Scaffold(
      body: Column(children: [
        Expanded(
          child: Container(
            width: 500.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topCenter,// End at the center-right
                colors: [Color(0xFF9f0202), Colors.black], // Define your gradient colors
                // Adjust stops to position the second color in the center
              ),
            ),
         child: SingleChildScrollView(
           child: Column(children: [
             SizedBox(height: 50.h),
             Padding(
               padding:  EdgeInsets.all(10.0),
               child: Center(
                 child: Text(
                   'BOOKING CANCELLATION',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25.sp,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
             ),
             SizedBox(height: 10.h),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical:20.h ),
               child: Container(
                 height: 200.h,
                 width: 380.w,
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
                 child: Padding(
                   padding:  EdgeInsets.all(28.0),
                   child: SingleChildScrollView(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
Text('Refund',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22.sp),),
                      SizedBox(height: 20.h,),
                       Text('If the user cancels the ride at least 3 hours before the scheduled time, a 50% payment refund will be processed.',style: TextStyle(color: Colors.white,fontSize: 18.sp),),
                     ],),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 10.h,),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical:0 ),
               child: Container(
                 height: 200.h,
                 width: 380.w,
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
                 child: Padding(
                   padding:  EdgeInsets.all(28.0),
                   child: SingleChildScrollView(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text('No Refund',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22.sp),),
                         SizedBox(height: 20.h,),
                         Text('Cancellations made within 3 hours of the scheduled ride time are not eligible for refunds.',style: TextStyle(color: Colors.white,fontSize: 18.sp),),
                       ],),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 20.h,),
             GestureDetector(
               onTap: (){
                 _launchCaller();
               },
               child: Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical:0 ),
                 child: Container(
                   height: 70.h,
                   width: 380.w,
                   decoration: BoxDecoration(
                     color: Colors.black45,
                     borderRadius: BorderRadius.circular(90.0),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.5),
                         spreadRadius: 2,
                         blurRadius: 5,
                         offset: Offset(0, 3),
                       ),
                     ],
                   ),
                   child: Center(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                       Icon(Icons.support_agent,color: Colors.yellowAccent,size: 40.sp,),
                       SizedBox(width: 10.w,),
                       Text('Customer Care Hotline',style: TextStyle(color: Colors.yellowAccent,fontSize: 22.sp,fontWeight: FontWeight.bold),)
                     ],),
                   ),
                 ),
               ),
             ),
           ],),
         ),
          ),
        )
      ],),
    );
  }
}
