import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homescreen.dart';
import 'chat_message.dart';

import 'chatscreen.dart';


class SupervisorChatScreen extends StatefulWidget{
  final Contact supervisor;

  const SupervisorChatScreen({Key? key,required this.supervisor}) : super(key: key);

  @override
  State<SupervisorChatScreen>createState()=> _SupervisorChatScreenState();
  



}

class _SupervisorChatScreenState extends State<SupervisorChatScreen>{
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages =[];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}
