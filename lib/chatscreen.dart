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


