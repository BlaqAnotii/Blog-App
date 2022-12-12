import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedpreference/homescreen.dart';
import 'package:sharedpreference/login_screen.dart';
import 'package:sharedpreference/model/user.dart';
import 'package:sharedpreference/preference/user_preference.dart';
import 'package:sharedpreference/provider/auth_provider.dart';
import 'package:sharedpreference/provider/blog_provider.dart';
import 'package:sharedpreference/provider/newsfeed_provider.dart';
import 'package:sharedpreference/provider/user_provider.dart';
import 'package:sharedpreference/registration_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => BlogProvider()),
     ChangeNotifierProvider(create: (context) => NewsProvider())
    
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUser() => UserPreference().getUser();

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();

                default:
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.data!.token == "null") {
                    return const LoginScreen();
                  } else {
                    return const HomeScreen();
                  }
              }
            }));
  }
}
