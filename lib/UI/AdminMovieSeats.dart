import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

class AdminMovieSeats extends StatefulWidget {
  @override

  String movieKey;
  String filmCategory;

  AdminMovieSeats(this.movieKey,this.filmCategory);

  _AdminMovieSeatsState createState() => _AdminMovieSeatsState(movieKey,filmCategory);
}



class _AdminMovieSeatsState extends State<AdminMovieSeats> {

  String movieKey;
  String filmCategory;
  _AdminMovieSeatsState(this.movieKey,this.filmCategory);

  List<Widget> listMovieSeats(DataSnapshot snapshot) {

    List<Widget> finalList = new List();
    int flag =1;
    for (int i = 1; i <= 5; i++) {
      List<Widget> list = new List();
      for(int j =1; j<=11;j++){
        if((j>4&&j<7)&& i<5 ){
          list.add(
              new Container(
                padding: new EdgeInsets.only(right:5,bottom: 5),
                width: 30,
                height: 30,
                child: Text("  "),
              )
          );
        }
        else{
          int index = flag;
          if(snapshot.value['seat$flag']=="false"){
            Color buttonColor = Colors.grey;
            list.add(
                new Container(
                  padding: new EdgeInsets.only(right:5,bottom: 5),
                  width: 30,
                  height: 30,
                  child: RaisedButton(
                    color: buttonColor,
                    onPressed: () {
                      Toast.show("Not Booked yet", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                      },
                  ),
                )
            );
          }else
          if(snapshot.value['seat$flag']!= "false"){
            Color buttonColor = Colors.blue;
            list.add(
                new Container(
                  padding: new EdgeInsets.only(right:5,bottom: 5),
                  width: 30,
                  height: 30,
                  child: RaisedButton(
                    onPressed: () {
                      Toast.show("User Name is "+snapshot.value['seat$index'],context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                    },
                    color: buttonColor,
                  ),
                )
            );
          }
          flag +=1;
        }
      }
      finalList.add(
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: list,
                ),
              )
            ],
          )
      );
    }
    return finalList;
  }

  final referenceDatabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final movieRef=referenceDatabase.reference().child("Movies").child(filmCategory).child(movieKey).child("Seats");
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber.shade300,
        title:new Row(
          children: [
            new Text(
              "Seats Booked",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      body: new Container(
        color: Colors.amber,
        child: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // new Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: listMovieSeats(),
                // ),
                new Container(
                  child: new Image.asset("images/theater.png"),
                  width: 250,
                  height: 200,
                ),
                new Container(
                  padding: new EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: new Text("Users Seats",style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                ),
                new Flexible(child: new FirebaseAnimatedList(shrinkWrap: true,
                  query: movieRef, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: listMovieSeats(snapshot),
                    );
                  },
                )),
                new SingleChildScrollView(
                  padding: new EdgeInsets.only(top: 10),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Row(
                        children: [
                          new Container(
                            padding: new EdgeInsets.fromLTRB(5, 5, 5, 5),
                            width: 30,
                            height: 30,
                            child: new RaisedButton(
                              color: Colors.blue,
                              onPressed: () {true;},
                            ),
                          ),
                          new Container(
                            child: new Text("Already Booked"),
                          ),
                        ],
                      ),
                      new Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                            padding: new EdgeInsets.fromLTRB(5, 5, 5, 5),
                            width: 30,
                            height: 30,
                            child: new RaisedButton(
                              color: Colors.grey,
                              onPressed: () {true;},
                            ),
                          ),
                          new Container(
                            child: new Text("Not Booked"),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}
