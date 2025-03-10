// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

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
  final bool isRead;
  final bool isDelivered;
  final bool isImage;
  final String imagePath;


  Message(this.text,this.isMe,this.time,{this.isRead=false,this.isDelivered=true,this.isImage=false,this.imagePath=''
  });




}

class FullScreenPhotoViewer extends StatelessWidget{
  final String imageUrl;
  final String contactName;
  const FullScreenPhotoViewer({
    Key? key,
    required this.imageUrl,
    required this.contactName,

}): super(key: key);

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

class FullScreenImageViewer extends StatelessWidget{
  final String imagePath;

  const FullScreenImageViewer({
    Key? key,
    required this.imagePath,

}) : super(key: key);


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

class ChatScreen extends StatefulWidget{
  final Contact contact;

  const ChatScreen({Key? key, required this.contact}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();

}



class _ChatScreenState extends State<ChatScreen>{

  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker =  ImagePicker();
  final List<Message> _messages =  [
    Message("Hello..,Mr.Albert!", true, "09:42", isRead: true),
    Message(
      "There is confusion about do \nwe have the session today",false,
      "09:45"),
    Message("...", true , "09:50", isRead: false),

  ];


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
        backgroundColor: const Color(0xFF000000),
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
                  radius: 20,


              backgroundImage: NetworkImage(widget.contact.imageUrl),
            ),
              ),
        ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                padding: const EdgeInsets.all(15),
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
          maxWidth: MediaQuery.of(context).size.width*0.75,

        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.lightGreen: const Color(0xFF90EE90),

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: message.isMe ? Radius.circular(18):Radius.circular(5),
            bottomRight: message.isMe ? Radius.circular(5): Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if(message.isImage && message.imagePath != null)...[
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imagePath: message.imagePath!,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(message.imagePath!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                ),

            ],
            Text(
              message.text,
              style: const TextStyle(color: Colors.black, fontSize: 16),

            ),
            const SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.min,

            Text(
              message.time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
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
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xff20283A),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file,color: Colors.white),
            onPressed: _getFromGallery,
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

