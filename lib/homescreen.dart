import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'search'
                  ),
                )

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}