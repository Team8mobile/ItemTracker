import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:project/Views/products/InsertProductView.dart';
// import 'package:project/Views/dashboard/dashboardView.dart';
import 'package:project/views/products/InsertProductView.dart';
import 'package:project/views/dashboard/dashboardView.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDDBlrt11AqsJqGk3Ocvu1tRqsL5Y_sE34",
      appId: "1:27340201446:android:6ba30c884e73a965544a27",
      messagingSenderId: "27340201446",
      projectId: "itemtracker-dev-50418",
    ),
  );


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

         routes: {
           '/' : (context) => InsertProductScreen(),
           '/dashboard': (context) => MyHomePage(),
           '/insertProduct' : (context)  => InsertProductScreen(),// Adjust according to your actual dashboard widget name
           // other routes
         }, // Set RegisterPage as the home screen

    );
  }
}


