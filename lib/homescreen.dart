import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'group_chat_screen.dart';

enum ChatCategory {lecturer, group}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  ChatCategory currentCategory = ChatCategory.lecturer;


  List<Contact>contacts=[
    Contact('Ms..Albert','You: Thank you sir.','9:40 AM',
    'https://i.pinimg.com/236x/89/d1/ef/89d1efb106a342203018a0b600cb3f34.jpg'),
    Contact('Mr.John','You: Ok,thanks!','9:25 AM',
    'https://i.pinimg.com/originals/87/66/e5/8766e5f221fa30acb078d6d2d6b7af81.jpg'),
    Contact('Mr.Loia','You: Ok miss,I will up... ','Fri',
    'https://static.vecteezy.com/system/resources/thumbnails/033/982/953/small/beautiful-girl-at-sunset-landscape-background-cartoon-summer-sunset-with-clouds-mountain-and-lake-anime-style-photo.jpg'),
    Contact('Ms.Kayal','There is a consern','Fri',
    'https://i.pinimg.com/736x/23/d2/bb/23d2bb062693ad8d9e6221ce4b4476d6.jpg'),
    Contact('Mr.Anne','Anne23@gmail.com','Tue',
    'https://i.pinimg.com/280x280_RS/85/14/3d/85143d043d763a77659dcfb85625bbe9.jpg'),

  ];

  List<Contact> groupChats = [
    Contact('Project Team 45','John: Let\'s meet tomorrow','10:20 AM',
      'https://static.vecteezy.com/system/resources/thumbnails/033/982/953/small/beautiful-girl-at-sunset-landscape-background-cartoon-summer-sunset-with-clouds-mountain-and-lake-anime-style-photo.jpg'),
  ];



  List<Contact>filteredContacts = [];
  List<Contact>currentList=[];


  @override
  void initState(){
    super.initState();
    filteredContacts = contacts;
    filteredContacts= currentList;
  }

  void filterContacts(String searchText){
    setState((){
      filteredContacts = contacts
          .where((contact) =>
           contact.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
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
      }
      filteredContacts=currentList;
    });
  }


  void contactOption(){
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF20283A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),


      ),
      constraints: const BoxConstraints(
        maxHeight: 120,
      ),
      builder: (BuildContext context){
        return Column(
          //mainAxisAlignment: MainAxisAlignment.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: const Text(
                'Delete Contact',
                 style: TextStyle(color: Colors.white,fontSize: 19),


              ),
              onTap: (){
                Navigator.pop(context);
                deleteOption();
        },


              ),
            // //const Divider(color: Colors.white),
            // ListTile(
            //   leading: const Icon(Icons.delete,color: Colors.white),
            //   title: const Text(
            //     'Delete Contact',
            //     style: TextStyle(color: Colors.white),
            //
            //   ),
            //   onTap: (){
            //     Navigator.pop(context);
            //     deleteOption();
            //
            //   },
            // )

          ],
        );
      }
    );
  }
  //
  // void addContactDialog(){
  //   final nameController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return AlertDialog(
  //         backgroundColor: const Color(0xFF20283A),
  //         title: const Text('Add new contact',style: TextStyle(color: Colors.white)),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Name',
  //                 labelStyle: TextStyle(color: Colors.white),
  //                 enabledBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.white),
  //
  //                 ),
  //               ),
  //               style: const TextStyle(color: Colors.white),
  //             ),
  //           ],
  //         ),
  //
  //         actions: [
  //           TextButton(
  //             onPressed: (){
  //               Navigator.of(context).pop();
  //
  //             },
  //             child: const Text('Cancel',style: TextStyle(color: Colors.white)),
  //
  //
  //           ),
  //
  //           TextButton(
  //             onPressed: (){
  //               if(nameController.text.isNotEmpty){
  //                 setState(() {
  //                   Contact(
  //                     nameController.text,
  //                     AutofillHints.email,
  //                     'now',
  //                     'https://i.pinimg.com/564x/e3/0f/47/e30f472f97a3b7090f62731ea87a84c2.jpg',
  //
  //                   );
  //                   filteredContacts=List.from(contacts);
  //                 });
  //               }
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Add',style: TextStyle(color: Colors.blueGrey)),
  //           )
  //
  //         ],
  //       );
  //     }
  //   );
  // }


  void deleteOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff20283A),
          title: const Text(
              'Select Contact to Delete',
              style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(contact.imageUrl),

                  ),
                  title: Text(
                      contact.name,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext confirmContext) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF20283A),
                          title: const Text('Confirm Delete',
                              style: TextStyle(color: Colors.white)),
                          content: Text(
                            'Are you Sure? ${contact.name}?',
                            style: const TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(confirmContext).pop();
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white)),


                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  contacts.removeAt(index);
                                  filteredContacts = List.from(contacts);
                                });
                                Navigator.of(confirmContext).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red)),

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
              child: const Text(
                  'Cancel', style: TextStyle(color: Colors.white)),


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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      CircleAvatar(
                        radius: 35,

                        backgroundImage: NetworkImage(
                         // 'https://static.vecteezy.com/system/resources/thumbnails/032/400/914/small_2x/charming-cute-3d-cartoon-girl-generate-ai-photo.jpg',
                          'https://i.pinimg.com/564x/e3/0f/47/e30f472f97a3b7090f62731ea87a84c2.jpg',

                      ),


                    ),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                      ),
                    ),

                    IconButton(
                      onPressed: contactOption,
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.black,

                        size: 38,
                      ),
                    )


                  ],
                ),
                const SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'search',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),

                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: filterContacts,
                ),

                const SizedBox(height: 20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoryButton('Lecturer',Icons.school,ChatCategory.lecturer,
                      Colors.grey),
                    _categoryButton('Group', Icons.group,ChatCategory.group,
                      Colors.grey),
                ],
                ),











                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(40),
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
              color: currentCategory == category ? color : Colors.grey),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
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
            radius: 20,
            backgroundImage: NetworkImage(contact.imageUrl),


          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(contact.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontSize: 17,
                        )),
                    ),
                    Text(contact.time,
                      style: const TextStyle(
                        color: Colors.black,
                      ),


                    ),
                  ],
                ),

                  const SizedBox(height: 5),
                    Text(contact.email,
                      style: const TextStyle(
                        color: Colors.black,
                      )

                    ),
                  ],
                ),

            ),


        ],
      ),
    );
  }
}
