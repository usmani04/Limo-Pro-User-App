import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return
      Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [    Color(0xFF9f0202),
                Colors.black,], // Adjust the colors as needed
              begin: Alignment.centerLeft, // Start from the center-left
              end: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.0.h),
                Center(
                  child: Text(
                    'ABOUT US',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50.0.h),
                Text(
                  'Welcome to Limo Services Pro where luxury meets professionalism. '
                      'With a decade of expertise in providing exceptional limousine services, '
                      'we take pride in offering a seamless, safe, and stylish travel experience. '
                      'At our core, we prioritize your comfort, safety, and satisfaction, '
                      'making us the preferred choice for discerning riders.',
                  style: TextStyle(fontSize: 16.0.sp,color: Colors.white),
                ),
                SizedBox(height: 20.0.h),
                Text(
                  'Our Commitment:',
                  style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                SizedBox(height: 10.0.h),
                Text(
                  'At Limo Services Pro, we boast a team of professional drivers with over 10 years of experience. '
                      'Each chauffeur undergoes rigorous training to ensure they deliver top-notch service '
                      'and adhere to the highest industry standards. Our drivers are not just professionals; '
                      'they are your dedicated partners in providing a smooth and enjoyable journey.',
                  style: TextStyle(fontSize: 16.0.sp,color: Colors.white),
                ),
                SizedBox(height: 20.0.h),
                Text(
                  'Key Benefits and Features:',
                  style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                SizedBox(height: 10.0.h),
                Text(
                  '• Experienced Professional Drivers: Our chauffeurs are seasoned professionals '
                      'with a wealth of experience, guaranteeing a safe and reliable ride.\n\n'
                      '• Smart Navigation: We utilize advanced GPS technology, including platforms like Waze and Google Maps, '
                      'to ensure efficient routes and on-time arrivals.\n\n'
                      '• Impeccable Presentation: Our drivers are dressed in smart attire – white shirts, ties, '
                      'and black suits – presenting a sharp and sophisticated image for your journey.\n\n'
                      '• In-Car Amenities: Enjoy complimentary Wi-Fi to stay connected, USB charging ports for your devices, '
                      'and refreshing bottled water, enhancing your travel experience.\n\n'
                      '• Respectful Environment: We uphold a strict policy against sexual harassment, ensuring a respectful '
                      'and secure atmosphere for all passengers.\n\n'
                      '• Additional Services: Customize your travel with options like multiple drop-off locations (additional charges apply) '
                      'and a 30-minute grace period for late arrivals.',
                  style: TextStyle(fontSize: 16.0.sp,color: Colors.white),
                ),
                SizedBox(height: 20.0.h),
                Text(
                  'Addressing Customer Pain Points:',
                  style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                SizedBox(height: 10.0.h),
                Text(
                  '• Professional Drivers: Experienced chauffeurs alleviate concerns about safety and expertise, '
                      'providing peace of mind to our riders.\n\n'
                      '• Smart Navigation: Efficient routes and timely arrivals minimize travel stress and enhance overall '
                      'convenience for our customers.\n\n'
                      '• In-Car Amenities: Complimentary Wi-Fi, USB charging, and refreshments cater to the needs of modern travelers, '
                      'ensuring a comfortable journey.\n\n'
                      '• Respectful Environment: Strict policies against harassment create a safe and comfortable space, '
                      'addressing passenger security concerns.',
                  style: TextStyle(fontSize: 16.0.sp,color: Colors.white),
                ),
                SizedBox(height: 20.0.h),
                Text(
                  'Credibility and Trust:',
                  style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                SizedBox(height: 10.0.h),
                Text(
                  '• Testimonials: Read glowing testimonials from our satisfied clients, '
                      'highlighting our professionalism, reliability, and outstanding service.\n\n'
                      '• Awards and Certifications: We are proud recipients of industry awards and certifications, '
                      'a testament to our commitment to excellence and customer satisfaction.',
                  style: TextStyle(fontSize: 16.0.sp,color: Colors.white),
                ),
                SizedBox(height: 30.0.h),
                Center(
                  child: Column(children: [
                    Text('2.0.0',style: TextStyle(color: Colors.white),),
                    Text('Developed By',style: TextStyle(color: Colors.white,),),
                    Container(

                        height: 80,width: 80,
                        child: Image.asset('images/y.gif',fit: BoxFit.cover,)),
                    Text('INFINITY SOLUTIONS',style: TextStyle(color: Colors.white,)),
                    Text('All Rights Reserved.',style: TextStyle(color: Colors.white,)),
                    Text('Copyright© 2023',style: TextStyle(color: Colors.white))
                  ],),
                )
              ],
            ),
          ),
        ),
      );

  }
}