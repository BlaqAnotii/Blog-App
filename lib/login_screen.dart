// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedpreference/homescreen.dart';
import 'package:sharedpreference/model/user.dart';
import 'package:sharedpreference/provider/auth_provider.dart';
import 'package:sharedpreference/provider/user_provider.dart';
import 'package:sharedpreference/registration_screen.dart';
import 'package:sharedpreference/utility/http_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  bool isChecked = false;

  final TextEditingController Email = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(children: [
            const Text(
              "WELCOME",
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 25, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                    height: 612,
                    width: double.infinity,
                    clipBehavior: Clip.none,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35))),
                    child: Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          const Text(
                            "Let get you started! This will only take a few\n minutes.",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == "") {
                                  return "Email is required";
                                }

                                return null;
                              },
                              controller: Email,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.mail),
                                labelText: 'Email',
                                hintText: "example@gmail.com",
                                fillColor:
                                    const Color.fromARGB(255, 233, 236, 238),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == "") {
                                  return "Incorrect password value";
                                }

                                return null;
                              },
                              controller: Password,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  icon: Icon(_isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                labelText: 'Password',
                                fillColor:
                                    const Color.fromARGB(255, 233, 236, 238),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(25),
                            child: authProvider.logginStatus == Status.loggingIn
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                      const Color.fromARGB(255, 2, 4, 104),
                                    )),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        authProvider
                                            .login(Email.text, Password.text)
                                            .then((response) {
                                          if (response["status"] == 500) {
                                            HttpService().showMessage(
                                                response["message"], context);
                                          } else {
                                            User user = User(
                                                user: response["data"].user,
                                                token: response["data"].token);
                                            userProvider.setUser(user);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()));
                                          }
                                        });
                                      }
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 50),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    )),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegistrationScreen()));
                                  },
                                  child: const Text(
                                    "Register Here",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            )
          ]),
        ),
      )),
    );
  }
}
