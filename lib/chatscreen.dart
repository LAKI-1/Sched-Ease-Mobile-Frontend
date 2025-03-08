import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Contact{
  final String name;
  final String email;
  final String time;
  final String imageUrl;

  Contact(this.name,this.email,this.time,this.imageUrl);
}

class Message{
  final String text;
  final bool isMe;
  final String time;

  Message(this.text,this.isMe,this.time);




}

class ChatScreen extends StatefulWidget{
  final Contact contact;

  const ChatScreen({Key? key, required this.contact}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen>{

  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages =  [
    Message("Hello", true, "09:42"),
    Message(
      "Sir",false,
      "09:45"),
    Message("...", true , "09:50"),

  ];


  void _sendMessage(){
    if(_messageController.text
        .trim()
        .isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            _messageController.text,
            true,
            "${DateTime
                .now()
                .hour}:${DateTime
                .now()
                .
            minute}",
          ),
        );
      }
      );

      _messageController.clear();
    }


  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0000ff),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // title: Text(widget.contact.name),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.contact.imageUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      //backgroundColor: const Color(0xffffffff),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
                padding: const EdgeInsets.all(15),
                itemCount: _messages.length,
                itemBuilder: (context, index){
                  final message= _messages[_messages.length = 1 - index];

                }

            ),
          ),
          _buildMessageInput(),
        ],


            )
          );

  }


  Widget _buildMessageBubble(Message message){
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : const Color(0xff20283A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 16),

            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xff20283A),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file,color: Colors.white),
            onPressed: () {},
          ),
          Expanded(

          child: TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Type message....',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xff18202D),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              )
            ),
          ),
          ),
          IconButton(
            icon: const Icon(Icons.send,color: Colors.white),
            onPressed: _sendMessage,
          )

        ],
      ),
    );
  }
}

