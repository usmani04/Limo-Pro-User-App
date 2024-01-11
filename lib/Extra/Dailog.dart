import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProgressDialog extends StatelessWidget
{
  String? message;
  ProgressDialog({this.message});


  @override
  Widget build(BuildContext context)
  {
    ScreenUtil.init(context);
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [

                 SizedBox(width: 6.0.w,),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),

                 SizedBox(width: 26.0.w,),

                Text(
                  message!,
                  style:  TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
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
