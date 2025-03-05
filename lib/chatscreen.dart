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
  final String isMe;
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
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Chat with ${widget.contact.name}'),

      ),
    );
  }
}

