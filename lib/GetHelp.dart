import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'FAQ.dart';
import 'msg.dart';

class Help extends StatefulWidget {
  final String? mail;
  const Help({this.mail});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9f0202), Colors.black],
            begin: Alignment.centerLeft,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding:  EdgeInsets.all(10.0.w),
              child: Center(
                child: Text(
                  'GET HELP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            buildOption(Icons.question_answer, 'FAQ', 1),
            buildDivider(),
            buildOption(Icons.gavel, 'Legal Info', 2),
            buildDivider(),
            buildOption(Icons.support_agent, 'Contact Us', 3),
          ],
        ),
      ),
    );
  }

  void navigateToScreen(int rowNumber) {
    switch (rowNumber) {
      case 1:
        Get.to(()=>FAQ(),transition: Transition.rightToLeft);
        break;
      case 2:
        Get.to(()=>Screen2(),transition: Transition.rightToLeft);

        break;
      case 3:
        Get.to(()=>ChatScreen(mail: widget.mail,),transition: Transition.rightToLeft);

        break;
      default:
      // Handle other cases if needed
        break;
    }
  }

  Widget buildOption(IconData icon, String text, int rowNumber) {
    return GestureDetector(
      onTap: () {
        // Handle option selection
        navigateToScreen(rowNumber);
      },
      child: Container(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 16.0.w),
                Text(text, style: TextStyle(fontSize: 16.0.sp, color: Colors.white)),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      thickness: 1,
      height: 1,
      color: Colors.white,
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: Center(
        child: Text('Screen 1 Content'),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Padding(
                padding:  EdgeInsets.all(10.0),
                child: Text(
                  'LEGAL INFO',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Terms and Conditions',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                      SizedBox(height: 20.h,),
                      Text('Welcome to Limo Services Pro Please read the following terms and conditions carefully before using our mobile application.\n\nAccount Creation: Users must create an account with accurate and up-to-date information to use the application by verifying email with OTP. Users are responsible for maintaining the confidentiality of their account information.\n\nBooking a Ride: Users can request a ride through the app by providing accurate pickup and drop-off locations. Once a ride request is submitted, the admin will review and confirm the booking.\n\nPayment Process: Users will receive a bill via email upon ride confirmation. Payments must be made promptly through the link which will be provided in the bill email.\n\nRide Confirmation: The admin will assign the driver once payment is successfully processed.Users will receive a notification on the application about ride confirmation.\n\nTracking the Ride: Users can track the location of the assigned driver in real-time using the app.Estimated arrival times will be provided, ensuring transparency and convenience.\n\nReviewing the Ride: After the completion of the ride, users are encouraged to provide feedback and reviews.Constructive feedback is appreciated to improve our services continuously.'
                        ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    ],
                  )
              ),
              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Rider Privacy Policy',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      SizedBox(height: 20.h,),
                      Text('At Limo Service Pro, we are committed to ensuring the privacy and security of our passengers.\n\nOur privacy policy outlines the measures we take to protect your personal information and ensure a safe and comfortable travel experience\n\n'
                          'Confidentiality and Discretion: We prioritize your confidentiality and discretion during your journey with us. Our professional drivers are trained to respect your privacy, ensuring that your conversations and personal matters remain confidential.\n\nData Protection: We collect and store your personal information securely, using industry-standard encryption methods. Your data is used solely for the purpose of providing our limousine services and is never shared with third parties without your consent.\n\nNo Smoking Policy: Our strict no smoking policy ensures a clean and healthy environment inside our limousines. We respect your right to breathe clean air, providing you with a smoke-free atmosphere throughout your ride. \n\nTransparent Pricing: We believe in transparent pricing to establish trust with our customers. Our pricing structure is clear and upfront, with no hidden fees or unexpected charges, ensuring a transparent and honest transaction.\n\nSafe Travel: Your safety is our top priority. Our drivers are experienced professionals who adhere to strict safety guidelines. We implement GPS tracking systems in our vehicles, allowing us to monitor your journey and ensure your safety throughout the ride.\n\nZero Tolerance for Sexual Harassment: We maintain a zero-tolerance policy against any form of harassment. Our commitment to your safety extends to creating an environment free from harassment, ensuring that you travel with peace of mind.\n\nFlexible Booking: We understand that travel plans can change. Our cancellation policy, while ensuring fairness to our drivers, also allows for flexibility, providing options for our customers in case unforeseen circumstance arise.',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    ],
                  )
              ),
              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('General Terms',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                      SizedBox(height: 20.h,),
                      Text('Code of Conduct: Users and drivers must adhere to a code of conduct, treating each other with respect and professionalism.\n\nCancellation Policy: Users are subject to the cancellation policy outlined in the app.Cancellation fees may apply in certain circumstances.\n\nTermination of Accounts: Violation of terms may result in the termination of user or driver accounts.\n\nApp Updates: Users and drivers are responsible for updating the app to the latest version for optimal performance.'
                        ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 3'),
      ),
      body: Center(
        child: Text('Screen 3 Content'),
      ),
    );
  }
}
