
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'MoreDetails.dart';
import 'MyreservedMovies.dart';


class Cinema extends StatefulWidget {



  String Email;
  Cinema(this.Email);

  @override
  State<StatefulWidget> createState() {
    return _CinemaPageState(Email);
  }

}

class _CinemaPageState extends State<Cinema> {

  final referenceDatabase = FirebaseDatabase.instance;

  String Email;
  _CinemaPageState(this.Email);

  final FirebaseAuth _Auth = FirebaseAuth.instance;
  Color Card_Colors = Colors.blue.shade300;

  //File image;
  Widget show_image(DataSnapshot snapshot){

    if(snapshot.value['Movie Image pass']==null){
      return new Text("No Image Selected");
    }else{
      // image=File(snapshot.value['Movie Image pass']);
      // return new Image.file(image);
      return new Image.network(snapshot.value['Movie Image pass']);
    }
  }

  Widget sizebox(DatabaseReference movieRef , String filmCategory){
    return SizedBox(
                        height: 315.0,
                        child: ListView(
            
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,                          
                          scrollDirection: Axis.horizontal,
                          children: [
                            new FirebaseAnimatedList(shrinkWrap: true,reverse: false,
                            query: movieRef,scrollDirection: Axis.horizontal, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                            return Card(
                              margin: new EdgeInsets.fromLTRB(35, 10, 35, 10),
                              //semanticContainer: true,
                              //shadowColor: Colors.black,
                              color: Card_Colors,
                              child: new Column(
                                children: [
                                  new Container(
                                      alignment: Alignment.topRight,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MoreDetails(Email,snapshot.value['Movie Title'],snapshot.value['Movie Description'],snapshot.value['Movie Time'],snapshot.value['Movie Image pass'],snapshot.key,filmCategory)) );
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
          title:new Row(
            children: [
              new Text(
                "Our Movies: ",
                style: new TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
              new Text(
                Email,
                style: new TextStyle(
                    color: Card_Colors,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          backgroundColor: Colors.amber.shade300,
        ),
        drawer: new Drawer(
          child: new Container(
            color: Colors.amber.shade300,
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReservedMovies(Email),) );
                      },
                      child: new Text("My reserved Movies",style: new TextStyle(fontSize: 18))
                  ),
                  new FlatButton(onPressed: null, child: new Text("My Profile",style: new TextStyle(fontSize: 18))),
                  new FlatButton(
                      onPressed: (){
                        _Auth.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil("/Login", (route) => false);
                    },
                      child: new Text("Log out",style: new TextStyle(fontSize: 18))),
                ],
              ),
            ),
          ),
        ),
        

              body: Container(
                color: Colors.amber,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 9)),
                          Text(
                          'Action',
                          style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ,color: Colors.red[900]),
                          textAlign: TextAlign.left,
                          ),
                          Text(
                          ' Movies',
                          style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),
                          ),
                        ],
                      ),
                      sizebox(movieRef1, "Action"),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 9)),
                          Text(
                          'Comedy',
                          style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ,color: Colors.cyan[100]),
                          textAlign: TextAlign.left,
                          ),
                          Text(
                          ' Movies',
                          style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),
                          ),
                        ],
                      ),
                      sizebox(movieRef2, "Comedy"),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 9)),
                          Text(
                          'Romantic',
                          style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ,color: Colors.pink[400]),
                          textAlign: TextAlign.left,
                          ),
                          Text(
                          ' Movies',
                          style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),
                          ),
                        ],
                      ),                      
                      sizebox(movieRef3, "Romantic"),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 9)),
                          Text(
                          'Mix',
                          style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ,color: Colors.grey[600]),
                          textAlign: TextAlign.left,
                          ),
                          Text(
                          ' Movies',
                          style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),
                          ),
                        ],
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
