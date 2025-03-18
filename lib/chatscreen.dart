

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'contact.dart';
import 'messages.dart';





class Messages{
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final bool isDelivered;
  final bool isImage;
  final String imagePath;


  Messages(this.text, this.isMe, this.time,
      {this.isRead = false, this.isDelivered = true, this.isImage = false, this.imagePath = ''
      });
}





class FullScreenPhotoViewer extends StatelessWidget{
  final String imageUrl;
  final String contactName;
  const FullScreenPhotoViewer({
    super.key,
    required this.imageUrl,
    required this.contactName,

});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
            contactName,
            style: const TextStyle(color: Colors.black),

        ),
      ),


      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: 'profile',
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingprogress){
                    if(loadingprogress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingprogress.expectedTotalBytes != null
                            ?loadingprogress.cumulativeBytesLoaded /
                            loadingprogress.expectedTotalBytes!
                            :null,

                        color: Colors.white,

                      ),
                    );
                  },


                  errorBuilder: (context,error,stackTrace){
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,

                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load this Image',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    );
                  }





              ),
            ),
          ),
        ),
      ),
    );
  }
}



class ChatScreen extends StatefulWidget{
  final Contact contact;


  const ChatScreen({
    super.key,
    required this.contact}) ;
  @override
  ChatScreenState createState() => ChatScreenState();

}



class ChatScreenState extends State<ChatScreen>{

  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker =  ImagePicker();
 // static final Map<String, List<Message>> chatHistory={};

  List<Message>_messages=[];



  @override
  void initState(){
    super.initState();
    _messages=widget.contact.messages;
  }


  void _sendMessage() {
    if (_messageController.text
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
                .minute}",
          ),
        );
      }
      );

      _messageController.clear();
    }
  }

  void _getFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      setState((){
        _messages.add(
          Message(
            "photo",
            true,
            "${DateTime
                .now()
                .hour}: ${DateTime
                .now()
                .minute}",
            isImage: true,
            imagePath: image.path,




          )
        );
      });
    }
  }

  void _openFullScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPhotoViewer(
          imageUrl: widget.contact.imageUrl,
          contactName: widget.contact.name,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFF3c5a7D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        //title: Text(widget.contact.name),
        title: Row(

          children: [
            GestureDetector(
              onTap: _openFullScreen,
              child: Hero(
                tag: 'profile',
                child: CircleAvatar(
                  radius: 20.r,


              backgroundImage: NetworkImage(widget.contact.imageUrl),
            ),
              ),
        ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],

        ),
      ), 
        
        
      
      backgroundColor: const Color(0xffffffff),


      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
                padding: EdgeInsets.all(15.w),
                itemCount: _messages.length,
                itemBuilder: (context, index){
                  final message= _messages[_messages.length - 1 - index];
                  return _buildMessageBubble(message);

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
        constraints: BoxConstraints(
          maxWidth: 0.75.sw,

        ),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        decoration: BoxDecoration(
          color: message.isMe ? Color(0xFFE0E0E0): const Color(0xFFE0E0E0),

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: message.isMe ? Radius.circular(18.r):Radius.circular(5.r),
            bottomRight: message.isMe ? Radius.circular(5.r): Radius.circular(18.r),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if(message.isImage && message.imagePath.isNotEmpty)...[
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imagePath: message.imagePath,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    File(message.imagePath),
                    width: 0.6.sw,
                    height:0.6.sw,
                    fit: BoxFit.cover,
                  ),
                ),
                ),

            ],
            Text(
              message.text,
              style: TextStyle(color: Colors.black, fontSize: 16.sp),

            ),
            SizedBox(height: 5.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.min,

            Text(
              message.time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12.sp,
              ),
            ),
            if(message.isMe)...[
              SizedBox(width: 5.w),
              Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 14,
                color: Colors.black,

              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFFF5F5F5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file,color: Colors.black),
            onPressed: _getFromGallery,
          ),
          Expanded(

          child: TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Type message....',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black,width: 2.0),

              ),
              filled: true,
              fillColor: Colors.white,

              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              )
            ),
          ),
          ),
          IconButton(
            icon: const Icon(Icons.send,color: Colors.black),
            onPressed: _sendMessage,
          )

        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget{
  final String imagePath;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,

  }) ;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain ,

            ),
          ),
        ),
      ),
    );
  }

}


