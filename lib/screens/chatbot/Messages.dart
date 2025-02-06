import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({super.key, required this.messages});
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemBuilder: (context, index) {
        bool isUserMessage = widget.messages[index]['isUserMessage'];
        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              // Add container for server reply messages
              if (!isUserMessage)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 35, // Space before the message bubble
                  child: Image.asset('assets/chatbotpage_images/chatbot_logo.png'),
                ),
              // Add container for user messages
              if (isUserMessage)
                Container(
                  margin: const EdgeInsets.only(right: 8), // Space between image and message
                  child: Image.asset(
                    'assets/chatbotpage_images/user.webp',
                    width: 35,
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                    topLeft: Radius.circular(isUserMessage ? 20 : 0),
                  ),
                  color: isUserMessage
                      ? Colors.grey.shade800
                      : Colors.grey.shade300, // Light grey for server messages
                ),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Text(
                  widget.messages[index]['message'],
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : Colors.black, // Black text for server messages
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
    );
  }
}
