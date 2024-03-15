import 'package:flutter/material.dart';
import 'Screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDDF6rfVXHAhnNQc1GWm0CXvCb5H9Kc7yQ",
        appId: "1:798633192887:web:48b9f7b75de2942aaa4c32",
        messagingSenderId: "798633192887",
        projectId: "crudtask-a5fec")
  );
  runApp(const Isoftronics());
}

class Isoftronics extends StatefulWidget {
  const Isoftronics({super.key});

  @override
  State<Isoftronics> createState() => _IsoftronicsState();
}

class _IsoftronicsState extends State<Isoftronics> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
