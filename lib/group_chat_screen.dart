import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'contact.dart';

import 'messages.dart';
import 'package:image_picker/image_picker.dart';

class FullScreenPhotoViewer extends StatelessWidget{
  final String imageUrl;
  final String contactName;

  const FullScreenPhotoViewer({
    super.key,
    required this.imageUrl,
    required this.contactName,

});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          contactName,
          style: TextStyle(color: Colors.white,fontSize: 20.sp),
      ),
        ),

    body: Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
         child: Hero(
          tag: 'profile',
         child: InteractiveViewer(
           boundaryMargin: EdgeInsets.all(20.w),
           minScale: 0.5,
           maxScale: 4.0,
           child: Image.network(
             imageUrl,
             fit: BoxFit.contain,
             loadingBuilder: (context,child,loadingProgress) {
               if(loadingProgress == null) return child;
               return Center(
                 child: CircularProgressIndicator(

                     value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded/
                        loadingProgress.expectedTotalBytes!
                      : null,
                     color: Colors.white,
                   strokeWidth: 4.w,
                   ),
                 );

             },
             errorBuilder: (context,error,stackTrace){
               return Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(
                     Icons.error_outline,
                     color: Colors.red,
                     size: 60.sp,
                   ),
                   SizedBox(height: 16.h),
                   Text(
                     'Failed to load this Image',
                     style: TextStyle(color: Colors.white,fontSize: 16.sp),
                   )
                 ],
               );
             }
           ),
         ),
      ),
    )
    ),

    );
  }
}


class GroupChatScreen extends StatefulWidget{
  final Contact group;

  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();

}


class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List _messages=[];


  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.group.messages);
  }
  void _sendMessage(){
    if(_messageController.text.trim().isNotEmpty){
      setState(() {
        _messages.add(
          Message(
            _messageController.text,
            true,
            "${DateTime.now().hour}:${DateTime.now().minute}",

        ));
      });
      _messageController.clear();
    }
  }


  void _getFromGallery() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);


    if(image != null){
      setState(() {
        _messages.add(
          Message(
            "photo",
            true,
            "${DateTime.now().hour}: ${DateTime.now().minute}",
            isImage: true,
            imagePath: image.path,
          ),
        );
      });
    }
  }

  void _openFullScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPhotoViewer(
          imageUrl: widget.group.imageUrl,
          contactName: widget.group.name,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C5A7D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: _openFullScreen,
              child: Hero(
                tag: 'profile',
                child: CircleAvatar(
                  radius: 20.w,
                  backgroundImage: NetworkImage(widget.group.imageUrl),
                ),
              ),
            ),

            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.name,
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

      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(15.w),
              itemCount: _messages.length,
              itemBuilder: (context,index){
                final message=_messages[_messages.length-1-index];
                return _buildMessageBubble(message);




              }
            ),
          ),
          _buildMessageInput()

        ],
      ),
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
          color: message.isMe ? Color(0xFFE0E0E0) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(18.r),
            // topLeft: Radius.circular(18),
            // topRight: Radius.circular(18),
            // bottomLeft: message.isMe ? Radius.circular(18) : Radius.circular(5),
            // bottomRight: message.isMe ? Radius.circular(5) : Radius.circular(18),


        ),

        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if(message.isImage && message.imagePath.isNotEmpty)...[
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imagePath: message.imagePath,
                       // contactName: widget.group.name,
                      )
                    ),

                  );
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(message.imagePath),
                    width: 0.5.sw,
                    height: 0.5.sw,
                    fit: BoxFit.cover,
                  ),

                ),
              )
            ],
            Text(
              message.text,
              style: TextStyle(color: Colors.black,fontSize: 16.sp),

              ),
            SizedBox(height: 5.h),
            Text(
              message.time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12.sp,
              ),
            ),

            if(message.isMe)...[
              const SizedBox(width: 5),
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
      padding: EdgeInsets.all(8.w),
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
              style: TextStyle(color: Colors.black,fontSize: 16.sp),
              decoration: InputDecoration(
                  hintText: 'Type message....',
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
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
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20.w),
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






