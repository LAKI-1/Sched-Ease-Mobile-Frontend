import 'package:flutter/material.dart';

import 'chat_message.dart';
import 'contact.dart';
import 'homescreen.dart';

class GroupChatScreen extends StatefulWidget{
  final Contact group;

  const GroupChatScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();

}


class _GroupChatScreenState extends State<GroupChatScreen>{
  final TextEditingController _messageController= TextEditingController();
  final List<ChatMessage> _message= [];
  
  
  @override 
  void iniState(){

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

