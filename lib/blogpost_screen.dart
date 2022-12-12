
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedpreference/newsfeed_screen.dart';
import 'package:sharedpreference/provider/auth_provider.dart';
import 'package:sharedpreference/provider/blog_provider.dart';
import 'package:sharedpreference/provider/user_provider.dart';
import 'package:sharedpreference/utility/http_service.dart';

class BlogPostScreen extends StatefulWidget {
  const BlogPostScreen({super.key});

  @override
  State<BlogPostScreen> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {

 final TextEditingController Title = TextEditingController();
  final TextEditingController EnterDetails = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

      final blogProvider = Provider.of<BlogProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
     return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
             child: blogProvider.loadingCicle == Status.loading
        ? const Center(child: CircularProgressIndicator())
        : 
         Form(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text("DeltaNews",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600
              ),),
              const SizedBox(height: 10),
              const Text("Create A Post",
              style: TextStyle(fontSize: 25,
               fontFamily: "Poppins",
               fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return "Title is required";
                      }
                      return null;
                    },
                    controller: Title,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Blog Title",
                        hintText: "Enter the blog description")),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return "Details is required";
                      }
                      return null;
                    },
                    controller: EnterDetails,
                    maxLength: 300,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the blog description...",
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)
                ),
                  onPressed: () {
             blogProvider.savePost(Title.text, EnterDetails.text, 
                          userProvider.changeName, userProvider.token).then((response){

                             HttpService().showMessage(response['message'], context);
                            clearForm();
                           // Navigator.pushReplacement(context,
                            // MaterialPageRoute(builder:
                             // (context) => const NewsFeedScreen(
                             // )));

                          });
                           //Navigator.pushReplacement(context,
                            // MaterialPageRoute(builder:
                              //(context) => const NewsFeedScreen(
                              //)));


                      },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 130,right: 130),
                    child: Text("Save",
                    style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
          )],
          ),
        ),
      ))
      );
  }
  void clearForm(){
    Title.clear();
    EnterDetails.clear();}
}