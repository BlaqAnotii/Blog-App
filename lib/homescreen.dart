import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedpreference/blogpost_screen.dart';
import 'package:sharedpreference/login_screen.dart';
import 'package:sharedpreference/newsfeed_screen.dart';
import 'package:sharedpreference/preference/user_preference.dart';
import 'package:sharedpreference/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        leading: const Icon(Icons.menu,color: Colors.white,),
        actions:  const [
          Icon(
            Icons.add,
            color: Colors.white,
          )
        ],
        title: const Text(
          "HOME",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer:  Drawer(
        width: 250.0,
         child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.purple),
                  child: Text(
                    "WELCOME",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
              ListTile(
                  leading: const Icon(Icons.home),
                  title: GestureDetector(
                    onTap: () {
          
                    },
                    child: const Text("Home"),
                  )),
              ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: GestureDetector(
                    onTap: () {
                     
                    },
                    child: const Text("Profile"),
                  )),
              ListTile(
                  leading: const Icon(Icons.message),
                  title: GestureDetector(
                    onTap: () {
                     Navigator.push(
                      context, 
                     MaterialPageRoute(builder: (context) => const BlogPostScreen(),)
                     );
                    },
                    child: const Text("Message"),
                  )),
              ListTile(
                  leading: const Icon(Icons.local_laundry_service),
                  title: GestureDetector(
                    onTap: () {
                     
                    },
                    child: const Text("Laundry Data"),
                  )),
              ListTile(
                leading: const Icon(Icons.settings),
                title: GestureDetector(
                  onTap: () {
                  },
                  child: const Text("Settings"),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: GestureDetector(
                  onTap: () {
                     UserPreference().removeUser();
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder:
                        ((context) => const LoginScreen())));
                  },
                  child: const Text("Logout"),
                ),
              )
            ],
          ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("WELCOME, ${userProvider.changeName}",
      style: const TextStyle(
            fontSize: 17,
            fontFamily: "Poppins",
            color: Colors.purple
      ),
      ),
      const SizedBox(height: 20,),
       ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        onPressed: () {
           
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder:
                        ((context) => const NewsFeedScreen())));
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 120,right: 120),
          child: Text("News Feed",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
        ),
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        onPressed: () {
           Navigator.push(
                      context, 
                     MaterialPageRoute(builder: (context) => const BlogPostScreen(),)
                     );
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 120,right: 120),
          child: Text("Add Post",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
        ),
        const SizedBox(height: 20,),
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        onPressed: () {
           UserPreference().removeUser();
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder:
                        ((context) => const LoginScreen())));
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 120,right: 120),
          child: Text("Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
        )
          ]
      ),
      )
    );
  }
}
