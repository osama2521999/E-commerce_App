import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_add.dart';
import 'admin_moredetails.dart';

import 'admin_notifications.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  
  File image;

  final referenceDatabase = FirebaseDatabase.instance;
  
  
  Widget show_image(DataSnapshot snapshot){

    if(snapshot.value['Movie Image pass']==null){
      return new Text("No Image Selected");
    }else{
      //image=File(snapshot.value['Movie Image pass']);
      //return new Image.file(image);
      return new Image.network(snapshot.value['Movie Image pass']);

    }
  }

  void moreDetails(DataSnapshot snapshot,String filmCategory){
    String movieTitle=snapshot.value['Movie Title'];
    String movieDescription=snapshot.value['Movie Description'];
    String movieTime=snapshot.value['Movie Time'];
    String imagePass=snapshot.value['Movie Image pass'];
    Navigator.push(context, MaterialPageRoute(builder: (context) => Admin_MoreDetails(movieTitle, movieDescription, movieTime, imagePass,snapshot.key,filmCategory)));
  }

    Color Card_Colors = Colors.blue.shade300;

    Widget sizebox(DatabaseReference movieRef ,String filmCategory){

      return SizedBox(
                        height: 365.0,
                        child: ListView(
            
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,                          
                          scrollDirection: Axis.horizontal,
                          children: [
                            new FirebaseAnimatedList(shrinkWrap: true,reverse: false,
                            query: movieRef,scrollDirection: Axis.horizontal, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                            return Card(
                              margin: new EdgeInsets.fromLTRB(35, 10, 35, 10),
                              semanticContainer: true,
                              shadowColor: Colors.black,
                              color: Card_Colors,
                              child: new Column(
                                children: [
                                  new Container(
                                      alignment: Alignment.topRight,
                                      child: new IconButton(icon: new Icon(Icons.delete), onPressed: () => movieRef.child(snapshot.key).remove())
                                  ),
                                  new Container(
                                    padding:new EdgeInsets.fromLTRB(0, 3, 0, 0),
                                    width: 190,
                                    height: 200,
                                    child: show_image(snapshot),
                                  ),
                                  new Container(
                                    padding:new EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: new Text(
                                      "Film Name:",
                                      style: new TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  new Container(
                                    padding: new EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    child: new Text(
                                      snapshot.value['Movie Title'],
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold 
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: new FlatButton(
                                      onPressed: () {
                                        moreDetails(snapshot,filmCategory);
                                      },
                                      child: new Text("More Details"),
                                      textColor: Colors.deepPurple,
                                    ),
                                  )
                                ],
                              ),
                            );                          
                            
                            },  
                            ),
                          ],
                        ),
                      );

    }



  @override
  Widget build(BuildContext context) {

    //final movieRef=referenceDatabase.reference().child("Movies");


    final movieRef1=referenceDatabase.reference().child("Movies").child("Action");
    final movieRef2=referenceDatabase.reference().child("Movies").child("Comedy");
    final movieRef3=referenceDatabase.reference().child("Movies").child("Romantic");
    final movieRef4=referenceDatabase.reference().child("Movies").child("Mix");

    return Scaffold(
      appBar: new AppBar(
        title: new Text(
            "Our Movies",
            style: new TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.amber.shade300,
        actions: [
          new IconButton(icon: new Icon(Icons.add), onPressed:() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Admin_Add(),));
          }, ),
          new IconButton(icon: new Icon(Icons.notifications), onPressed:() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Admin_notifications(),));
          }, ),
        ],
      ),


      body: Container(
                color: Colors.amber,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      Text(
                        'Action Movies',
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      sizebox(movieRef1, "Action"),
                      Text(
                        'Comedy Movies',
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      sizebox(movieRef2, "Comedy"),
                      Text(
                        'Romantic Movies',
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      sizebox(movieRef3, "Romantic"),
                      Text(
                        'Mix Movies',
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ), 
                      sizebox(movieRef4, "Mix"),


                      Card(
                        color: Colors.amber,
                        child: ListTile(title: Text(''), subtitle: Text('')),
                      ),

                    ],
                  ),
                ),
              )
            
    
    );
  }
}


