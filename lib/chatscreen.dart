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
                )
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Chat with ${widget.contact.name}'),


            )
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

          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Type message....',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              )
            ),
          )

        ],
      ),
    );
  }
}

