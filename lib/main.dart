import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_commrece_app/UI/Login.dart';
import 'package:e_commrece_app/UI/cinema.dart';
import 'package:e_commrece_app/UI/sign_up.dart';
import 'package:e_commrece_app/UI/MoreDetails.dart';
import 'package:e_commrece_app/UI/MyreservedMovies.dart';
import 'UI/admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      // initialRoute: String,
      routes: <String,WidgetBuilder>{
        '/Login' : (BuildContext context)=>Login(),
        '/SignUp' : (BuildContext context)=>SignUP(),
        '/Cinema' : (BuildContext context)=>Cinema("No User yet"),
        '/MoreDetails' : (BuildContext context)=>MoreDetails("No User yet","","","","","",""),
        '/ReservedMovies' : (BuildContext context)=>ReservedMovies("No User yet"),
        '/Admin' : (BuildContext context)=>Admin(),
      },

      home: Login(),
    );
  }
}



