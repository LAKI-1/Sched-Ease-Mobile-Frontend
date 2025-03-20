import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newchatapp/messages.dart';
import 'chatscreen.dart';
// import 'group_chat_screen.dart';
// import 'supervisor_chat_screen.dart';
import 'contact.dart';

enum ChatCategory {lecturer, group, supervisor }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  ChatCategory currentCategory = ChatCategory.lecturer;


  List<Contact>contacts=[
    Contact('Ms..Albert','You: Thank you sir.','9:40 AM',
    'https://i.pinimg.com/236x/89/d1/ef/89d1efb106a342203018a0b600cb3f34.jpg',
    [
      Message('Hello...',false,'9.30 AM'),
      Message('could you send me the email?',true,'9:35 AM'),
      Message('yes.',false,'9.40 AM'),



    ]),

    Contact('Mr.John','You: Ok,thanks!','9:25 AM',
    'https://i.pinimg.com/originals/87/66/e5/8766e5f221fa30acb078d6d2d6b7af81.jpg',
    [
      Message('Can you join the meeting? ',false,'11.00 AM'),
      Message('yeah..sure',true,'11.00 AM'),
      Message('ok',false,'11:01 AM'),

    ]),
    Contact('Mr.Loia','You: Ok miss,I will up... ','Fri',
    'https://static.vecteezy.com/system/resources/thumbnails/033/982/953/small/beautiful-girl-at-sunset-landscape-background-cartoon-summer-sunset-with-clouds-mountain-and-lake-anime-style-photo.jpg',
    [
      Message('Good morning sir...',true,'8:10 AM'),
      Message('good morning..',false,'9.00 AM'),


    ]),
    Contact('Ms.Kayal','There is a consern','Fri',
    'https://i.pinimg.com/736x/23/d2/bb/23d2bb062693ad8d9e6221ce4b4476d6.jpg',
    [
      Message('What is the idea? ',false,'15:02 PM'),
      Message('.....',true,'18.00 PM'),

    ]),




    Contact('Mr.Anne','Anne23@gmail.com','Tue',
    'https://i.pinimg.com/280x280_RS/85/14/3d/85143d043d763a77659dcfb85625bbe9.jpg',
    [


    ]),

  ];

  List<Contact> groupChats = [
    Contact('Project Group 45','John: Let\'s meet tomorrow','10:22 AM',
      'https://static.vecteezy.com/system/resources/thumbnails/033/982/953/small/beautiful-girl-at-sunset-landscape-background-cartoon-summer-sunset-with-clouds-mountain-and-lake-anime-style-photo.jpg',
    [

      Message('who is the leader? ',false,'7:00 AM'),


    ]),
    Contact('Team Leaders','Athor: Can we discuss with our all team leadres?','9:23 PM',
      'https://www.google.com/search?sca_esv=d425b5dac0dba72a&q=group+pictures+cartoon&udm=2&fbs=ABzOT_CWdhQLP1FcmU5B0fn3xuWpA-dk4wpBWOGsoR7DG5zJBkzPWUS0OtApxR2914vrjk4ZqZZ4I2IkJifuoUeV0iQtlsVaSqiwnznvC1owt2z2tTdc23Auc6X4y2i7IIF0f-daFQAnIISUeBdGNO3Bl2VmXrYULqbJwOFxhGBxjDvPi7AXljWm69dCJGJtZf49EuPbm-5He1d5dYd0SRT0i0ep72Wwyw&sa=X&ved=2ahUKEwiZo4vo3oOMAxXtF1kFHVXUGJwQtKgLegQIEhAB&biw=1536&bih=730&dpr=1.25#vhid=UMcxWS1pi1jGrM&vssid=mosaic',[

        Message('.....',true,'8:00 PM'),

        ]),

  ];

  List<Contact> supervisorChats = [
    Contact('Mr. William','You: Sir.Can we get a meeting today?','11.10 AM',
      'https://i.pinimg.com/280x280_RS/85/14/3d/85143d043d763a77659dcfb85625bbe9.jpg',
    [

      Message('you can contact me',false,'10.00 AM'),

    ]),
    Contact('Mr.Charles','You: Can we discuss today? ','6:10 AM',
      'https://photosbook.in/wp-content/uploads/stylish-cartoon-boy-dp44.jpg',
    [
      Message('Hello...Sir',true,'11.00 AM'),

    ]),
    Contact('Ms. Marry','Please confirm it','6:08 PM',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ4HDkgF6qFd8gDxVCr6_n1INZ6phJSnDSqg&s',
        [
          Message('Tomorrow',false,'12.10 PM'),
          Message('Thank you miss',true,'12.12 PM'),

    ]),
  ];



  List<Contact>filteredContacts = [];
  List<Contact>currentList=[];


  @override
  void initState(){
    super.initState();
    currentList = contacts;
    filteredContacts= currentList;
  }

  void filterContacts(String searchText){
    setState((){

      if(searchText.isEmpty){
        filteredContacts=currentList;

      }else{
        filteredContacts=currentList
            .where((contact)=>
              contact.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  void switchCategory(ChatCategory category){
    setState(() {
      currentCategory = category;

      switch(category){
        case ChatCategory.lecturer:
          currentList = contacts;
          break;
        case ChatCategory.group:
          currentList = groupChats;
          break;

        case ChatCategory.supervisor:
          currentList=supervisorChats;
          break;
      }
      filteredContacts=currentList;
    });
  }


  void contactOption(){
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF20283A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),


      ),
      constraints: BoxConstraints(
        maxHeight: 120.h,
      ),
      builder: (BuildContext context){
        return Column(
          //mainAxisAlignment: MainAxisAlignment.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white,size: 24.sp),
              title: Text(
                'Delete Contact',
                 style: TextStyle(color: Colors.white,fontSize: 19.sp),


              ),
              onTap: (){
                Navigator.pop(context);
                deleteOption();


        },


              ),

          ],
        );
      }
    );
  }




  void deleteOption() {

    List<Contact>currentContactList=currentList;

    String title='';

    if(currentCategory==ChatCategory.group){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: const Color(0xFF20283A),
            title: Text(
              'Group Chat Deletion',
              style: TextStyle(color: Colors.white,fontSize: 20.sp),

            ),
            content: Text(
              'Group cannot be Deleted',
              style: TextStyle(color: Colors.white,fontSize: 16.sp),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',style: TextStyle(color: Colors.white,fontSize: 16.sp),
                ),
              ),
            ],
          );
        }
      );
      return;
    }

    if (currentCategory == ChatCategory.lecturer) {
      title='Select Contact to delete';
    } else if (currentCategory == ChatCategory.supervisor) {
      title='Select supervisor to delete';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff20283A),
          title:Text(
              title,
              style: TextStyle(color: Colors.white,fontSize: 20.sp)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currentContactList.length,
              itemBuilder: (context, index) {
                final contact = currentContactList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20.w,
                    backgroundImage: NetworkImage(contact.imageUrl),

                  ),
                  title: Text(
                      contact.name,
                      style: TextStyle(color: Colors.white,fontSize: 16.sp)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext confirmContext) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF20283A),
                          title: Text('Confirm Delete',
                              style: TextStyle(color: Colors.white,fontSize: 20.sp)),
                          content: Text(
                            'Are you Sure? ${contact.name}?',
                            style: TextStyle(color: Colors.white,fontSize: 16.sp),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(confirmContext).pop();
                              },
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.white,fontSize: 16.sp)),


                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  // contacts.removeAt(index);

                                  if (currentCategory case ChatCategory.lecturer) {
                                    contacts.removeAt(index);
                                  } else if (currentCategory case ChatCategory.supervisor) {
                                    supervisorChats.removeAt(index);
                                  }
                                  filteredContacts = List.from(currentList);
                                });
                                Navigator.of(confirmContext).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red,fontSize: 16.sp)),

                            ),
                          ],

                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                  'Cancel', style: TextStyle(color: Colors.white,fontSize: 16.sp)),


            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      CircleAvatar(
                        radius: 35.w,

                        backgroundImage: const NetworkImage(
                          'https://i.pinimg.com/564x/e3/0f/47/e30f472f97a3b7090f62731ea87a84c2.jpg',

                      ),


                    ),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                      ),
                    ),

                    IconButton(
                      onPressed: contactOption,
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.black,

                        size: 38.sp,
                      ),
                    )


                  ],
                ),
                SizedBox(height: 20.h),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'search',
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 16.sp),
                    prefixIcon: Icon(Icons.search,color: Colors.grey,size: 24.sp),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),

                  ),
                  style: TextStyle(color: Colors.black,fontSize: 16.sp),
                  onChanged: filterContacts,
                ),

                SizedBox(height: 20.h),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoryButton('Lecturer',Icons.school,ChatCategory.lecturer,
                      Colors.grey),
                    _categoryButton('Group', Icons.group,ChatCategory.group,
                      Colors.grey),
                    _categoryButton('Supervisor',Icons.person,ChatCategory.supervisor,
                      Colors.grey),
                ],
                ),
                SizedBox(height: 20.h),











                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.r),
                        topRight: Radius.circular(40.r),
                      ),

                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,


                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index){
                        final contact= filteredContacts[index];
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  contact: contact,
                                ),
                              ),
                            );



                          },
                          child: _buildContactRow(contact),
                        );

                      },
                    ),

                    ),
                  ),









                ),

              ],
            ),

        ),
      ),
    ));


  }

  Widget _categoryButton(
      String text, IconData icon, ChatCategory category, Color color) {
    return GestureDetector(
      onTap: () => switchCategory(category),
        child: Column(
          children: [
          Icon(icon,
              size: 24.sp,
              color: currentCategory == category ? color : Colors.grey),
          SizedBox(height: 5.h),
          Text(text,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: currentCategory == category ? color : Colors.grey)),
        ],
      ),
    );
  }




  Widget _buildContactRow(Contact contact){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.w,
            backgroundImage: NetworkImage(contact.imageUrl),


          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(contact.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontSize: 17.sp,
                        )),
                    ),
                    Text(contact.time,
                      style: const TextStyle(
                        color: Colors.black,
                      ),


                    ),
                  ],
                ),

                  SizedBox(height: 5.h),
                    Text(contact.email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                      overflow: TextOverflow.ellipsis,

                    ),
                  ],
                ),

            ),


        ],
      ),
    );
  }
}
