import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cinema.dart';


class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<Login> {

  String email ;
  String password ;
  String passwordConfirm = "" ;



  final FirebaseAuth _Auth = FirebaseAuth.instance;

  
  void _Login(String email,String password){
    String m_email = email.substring(0,email.indexOf("@"));
    _Auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      print(value);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cinema(m_email),
          )
      );
    }).catchError((err){
      print(err);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            title:  new Text("Login"),
            content: new SingleChildScrollView(
              child: new Text("Login Failed"),
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


  final formkey = GlobalKey<FormState>();
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        body: new Container(
          color: Colors.amber,
          padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: new Center(
            child: new SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: new Image.asset("images/c.png"),
                    width: 100,
                    height: 100,
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
                        hintText: "Enter Your Email",
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
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: "Enter Your Password",
                      ),
                      onChanged: (value) => password=value,
                    ),
                    width: 200,
                  ),
                  new Container(
                    padding: new EdgeInsets.fromLTRB(100, 10, 0, 0),
                    child: RaisedButton(
                      onPressed:() {
                        setState(() {
                          flag=true;
                        });
                        if(email=="admin"&&password=="admin"){
                          Navigator.pushNamed(context, "/Admin");
                        }else
                        if (formkey.currentState.validate()) {
                          formkey.currentState.save();
                          // _login();
                          _Login(email,password);
                        }
                      } ,
                      child: new Text("Login"),
                      color: Colors.blue,
                    ),
                  ),
                  new Container(
                    padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text("If You not have Email before,You can"),
                        new FlatButton(
                            onPressed: (){Navigator.of(context).pushNamed("/SignUp");},
                            child: new Text(
                              "Sign Up",
                              style: new TextStyle(color: Colors.blue),
                            ),
                        )
                      ],
                    )
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

