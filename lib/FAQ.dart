import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: "How do I create an account?",
      answer:
      "You can create an account by providing accurate information and verifying your email with the OTP sent during the registration process.",
    ),
    FAQItem(
      question: "How do I book a ride?",
      answer:
      "Simply submit a ride request through the app by providing accurate pickup and drop-off locations. The admin will review and confirm the booking.",
    ),
    FAQItem(
      question: "When and how do I make payments?",
      answer:
      "Payments must be made promptly upon receiving the bill via email. A payment link will be provided for your convenience.",
    ),
    FAQItem(
      question: "Can I track my ride in real-time?",
      answer:
      "Yes, you can track the assigned driver's location in real-time through the app, along with estimated arrival times.",
    ),
    FAQItem(
      question: "How can I provide feedback after the ride?",
      answer:
      "After the ride is completed, you're encouraged to provide feedback and reviews through the app.",
    ),
    // Add more FAQ items here


    // Add more driver FAQs here
    FAQItem(
      question: "What is the Code of Conduct for users and drivers?",
      answer: "Users and drivers are expected to treat each other with respect and professionalism.",
    ),
    FAQItem(
      question: "What is the cancellation policy?",
      answer: "Users are subject to the cancellation policy outlined in the app, and cancellation fees may apply in certain circumstances.",
    ),
    FAQItem(
      question: "What happens if I violate the terms and conditions?",
      answer: "Violation of terms may result in the termination of user or driver accounts.",
    ),
    FAQItem(
      question: "How do I stay updated with the latest app features?",
      answer: "Users and drivers are responsible for updating the app to the latest version for optimal performance.",
    ),
    FAQItem(
      question: "What is the aim of Limo Services Pro?",
      answer: "Limo Services Pro aims to provide a seamless and reliable transportation experience for all users.",
    ),
    // Add more general FAQs here
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Start from the center-left
            end: Alignment.centerRight, // End at the center-right
            colors: [Color(0xFF9f0202), Colors.black], // Define your gradient colors
            // Adjust stops to position the second color in the center
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'F.A.Q.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Expanded(
              child: ListView.builder(
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: FAQItemWidget(
                      faqItem: faqItems[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQItemWidget extends StatelessWidget {
  final FAQItem faqItem;

  FAQItemWidget({required this.faqItem});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ListTile(
        title: Container(
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
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,color: Colors.white,size: 18.sp,),
SizedBox(width: 10.w,),
                  Text(
                    faqItem.question,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(faqItem.question),
                content: Text(faqItem.answer),
              );
            },
          );
        },
      ),
    );
  }
}
