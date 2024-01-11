import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String? mail;

  const ChatScreen({this.mail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Message> _messages = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchMessages();
    });
  }

  Future<void> fetchMessages() async {
    final url = 'https://limo101.pythonanywhere.com/getusermessage/';
    final body = {
      "email": widget.mail,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        if (data.containsKey('user_messages')) {
          List<Message> loadedConversation =
          List<Map<String, dynamic>>.from(
            jsonDecode(response.body)['user_messages'],
          )
              .map((map) => Message.fromJson(map))
              .toList()
              .reversed
              .toList();

          setState(() {
            _messages = loadedConversation;
          });
        } else {
          print('Response does not contain the expected "user_messages" field.');
        }
      } else {
        print(response.statusCode);
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendMessage(String message) async {
    final url = 'https://limo101.pythonanywhere.com/sendmessage/';
    final body = {
      "email": widget.mail,
      "message": message,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        fetchMessages();
        print('Message sent successfully');
      } else {
        print('Failed to send message');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('Error: $e');
    }
  }





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
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'CHAT WITH US',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true, // Set reverse to true
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),

            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xFF00b22d),
                          width: 3.0.w, // Increase the border thickness
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: '  Type a message here.......',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Color(0xFF00b22d),
                              width: 1.0.w, // Increase the focused border thickness
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Color(0xFF00b22d), // Change the hint text color to green
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      final message = _textEditingController.text;
                      if (message.isNotEmpty) {
                        sendMessage(message);
                        _textEditingController.clear();

                        // Close the keyboard
                        FocusScope.of(context).unfocus();

                      }
                    },
                    child: Container(
                      height: 65.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.send,
                        color: Color(0xFF00b22d),
                        size: 40.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final int messageId;
  final String message;
  final String reply;

  Message({
    required this.messageId,
    required this.message,
    required this.reply,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      message: json['message'],
      reply: json['reply'],
    );
  }
}

Widget _buildMessageItem(Message message) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF25a000),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                            ),
                          ),
                          child: Text(
                            '${message.message}',
                            style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (message.reply.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                  padding: EdgeInsets.all(10.0),
                  constraints: BoxConstraints(
                      maxWidth: 350.w
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    '${message.reply}',
                    style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
                    softWrap: true,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
