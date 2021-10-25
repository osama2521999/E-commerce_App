import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'cinema.dart';


class SignUP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUPState();
  }

}

class _SignUPState extends State<SignUP> {

  String email ;
  String password ;
  String passwordConfirm = "" ;

  final FirebaseAuth _Auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance;


  void _singup2(String email,String password,DatabaseReference ref_user){

    _Auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      print(value);
      _showMyDialog(ref_user);
    }).catchError((err){
      print(err);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            title:  new Text("SignUp"),
            content: new SingleChildScrollView(
              child: new Text("Failed SignUp"),
            ),
            actions: [
              new FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: new Text("OK")
              )
            ],
          );
        },
      );
    });
  }

  Future<void> _singup() async {
    FirebaseUser User = (await _Auth.createUserWithEmailAndPassword(email: email, password: password)).user ;
  }

  Future<void> _showMyDialog(DatabaseReference ref_user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text("Submit"),
          content: new SingleChildScrollView(
            child: new Text("Successful submitting"),
          ),
          actions: [
            new FlatButton(
                onPressed: (){
                  // _singup();
                  String m_email = email.substring(0,email.indexOf("@"));
                  //ref_user.child(m_email).child("MidNight").child("Booking_before").set("0");
                  //ref_user.child(m_email).child("MidMorning").child("Booking_before").set("0");

                  //ref_user.child(m_email).child("Booking_before").set("0");

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Cinema(m_email),));
                  },
                child: new Text("Login")
            )
          ],
        );
      },
    );
  }



  final formkey = GlobalKey<FormState>();
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    final ref_user=referenceDatabase.reference();
    return Form(
      key: formkey,
      child: Scaffold(
          body: new Container(
            color: Colors.amber,
            child: new Center(
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      child: new Image.asset("images/c.png"),
                      width: 100,
                      height: 100,
                      padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                    new Container(
                      padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: new TextFormField(
                        autovalidate: flag,
                        validator: (value) {
                          if(value.isEmpty){
                            return "this field is mandatory";
                          }
                          String p ="[a-zA-Z0-9\+\.\%\-\+]{1,256}"+"\\@"+"[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"+"("+"\\."+"[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}"+")+";
                          RegExp regexp = new RegExp(p);
                          if(regexp.hasMatch(value)){
                            return null;
                          }
                          return "This is not valid Email";
                        },
                        decoration: new InputDecoration(
                          hintText: "Enter Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email=value,
                      ),
                      width: 200,
                    ),
                    new Container(
                      padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: new TextFormField(
                        autovalidate: flag,
                        validator: (value) {
                          if(value.isEmpty){
                            return "this field is mandatory";
                          }
                          if(value.length<7){
                            return "Password must be more than 7 characters ";
                          }
                          return null;
                        },
                        autocorrect: false,
                        obscureText: true,
                        decoration: new InputDecoration(
                          hintText: "Enter Password",
                        ),
                        onChanged: (value) => password=value,
                      ),
                      width: 200,
                    ),
                    new Container(
                      padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: new TextFormField(
                        autovalidate: flag,
                        validator: (value) {
                          if(passwordConfirm!=password){
                            return "Passwords must be match";
                          }
                          return null;
                        },
                        autocorrect: false,
                        obscureText: true,
                        decoration: new InputDecoration(
                          hintText: "Confirm Password",
                        ),
                        onChanged: (value) =>passwordConfirm=value ,
                      ),
                      width: 200,
                    ),
                    new Container(
                      padding: new EdgeInsets.fromLTRB(100, 10, 0, 0),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            flag=true;
                          });
                          if (formkey.currentState.validate()) {
                            formkey.currentState.save();
                            _singup2(email, password, ref_user);
                          }
                        },
                        child: new Text("Submit"),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}