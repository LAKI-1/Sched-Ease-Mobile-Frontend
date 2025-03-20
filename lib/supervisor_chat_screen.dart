import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'dart:io';
import 'contact.dart';
import 'package:image_picker/image_picker.dart';
import 'messages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';









class SupervisorChatScreen extends StatefulWidget{
  final Contact supervisor;

  const SupervisorChatScreen({super.key,required this.supervisor});

  @override
  State<SupervisorChatScreen>createState()=> _SupervisorChatScreenState();
  



}

class _SupervisorChatScreenState extends State<SupervisorChatScreen>{
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages =[];
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();



  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.supervisor.messages);
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
          imageUrl: widget.supervisor.imageUrl,
          contactName: widget.supervisor.name,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return ScreenUtilInit(
      designSize: const Size(360,690),
    builder: (context,child){
    return Scaffold(
    appBar: AppBar(
    backgroundColor: const Color(0xFF3C5A7D),
    leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
    onPressed: () => Navigator.pop(context),
    ),
    title: Row(
    children: [
    GestureDetector(
    onTap: _openFullScreen,
    child: Hero(
    tag: 'profile',
    child: CircleAvatar(
    radius: 20.r,
    backgroundImage: NetworkImage(widget.supervisor.imageUrl),
    ),
    ),
    ),

    SizedBox(width: 10.w),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    widget.supervisor.name,
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

    backgroundColor: const Color(0xFFFFFFFF),
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
    },
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomLeft: message.isMe ? Radius.circular(18.r) : Radius.circular(5.r),
              bottomRight: message.isMe ? Radius.circular(5.r) : Radius.circular(18.r),

            )
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
                    width: 200.w,
                    height: 200.h,
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
              SizedBox(width: 5.w),
              Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 14.sp,
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
            icon: Icon(Icons.attach_file,color: Colors.black,size: 24.sp,),
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
                    borderSide: BorderSide(color: Colors.black,width: 2.w),

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
            icon: Icon(Icons.send,color: Colors.black,size: 24.sp),
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
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20.sp),
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
              width: 0.9.sw,
              height: 0.9.sh,
              fit: BoxFit.contain ,

            ),
          ),
        ),
      ),
    );
  }

}








// @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }
  

