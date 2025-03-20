class Message{
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final bool isDelivered;
  final bool isImage;
  final String imagePath;

  Message(this.text,this.isMe,this.time,{this.isRead=false,this.isDelivered=true,this.isImage=false,this.imagePath=''});
}