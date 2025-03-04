import 'package:flutter/material.dart';
import 'chatscreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {


  List<Contact>contacts=[
    Contact('Ms..Albert','You: Thank you sir.','9:40 AM',
    'https://static.vecteezy.com/system/resources/thumbnails/032/400/914/small_2x/charming-cute-3d-cartoon-girl-generate-ai-photo.jpg'),
    Contact('Mr.John','You: Ok,thanks!','9:25 AM',
    'https://www.seekpng.com/png/full/115-1150053_avatar-png-transparent-png-royalty-free-default-avatar.png'),
    Contact('Mr.Loia','You: Ok miss,I will up... ','Fri',
    'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
    Contact('Ms.Kayal','There is a consern','Fri',
    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
    Contact('Mr.Anne','Anne23@gmail.com','Tue',
    'https://www.pngfind.com/pngs/m/112-1128448_avatar-png-transparent-png-royalty-free-default-avatar.png'),

  ];

  List<Contact>fileteredContacts=[];


  @override
  void initState(){
    super.initState();
    fileteredContacts = contacts;
  }

  void filteredContacts(String searchText){
    setState((){
      fileteredContacts = contacts
          .where((contact) =>
           contact.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff18202D),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      ClipOval(

                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/thumbnails/032/400/914/small_2x/charming-cute-3d-cartoon-girl-generate-ai-photo.jpg',
                          height: 60,
                      ),


                    ),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(
                        Icons.camera_alt_sharp,
                        color: Colors.white,

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
                    fillColor: const Color(0xff20283A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    )
                  ),
                  style: const TextStyle(color: Colors.white),
                ),



                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(40),
                      ),

                    ),
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index){
                        final contact=filteredContacts[index];
                        return InkWell(
                          onTap: (){


                          },
                        );

                      },
                    ),

                    ),
                  ),










                
              ],
            ),
          ),
        ),
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

        ],
      ),
    );
  }
}