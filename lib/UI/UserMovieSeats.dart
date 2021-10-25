import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMovieSeats extends StatefulWidget {

  String email;
  String movieKey;

  String filmCategory;

  String movieName;
  String image_pass;
  String movieTime;
  
  UserMovieSeats(this.email,this.movieKey,this.filmCategory,this.movieName,this.image_pass,this.movieTime);

  @override
  _UserMovieSeatsState createState() => _UserMovieSeatsState(email,movieKey,filmCategory,movieName,image_pass,movieTime);
}

class _UserMovieSeatsState extends State<UserMovieSeats> {



  String email;
  String movieKey;

  String filmCategory;

  String v;

  String movieName;
  String image_pass;
  String movieTime;
  
  _UserMovieSeatsState(this.email,this.movieKey,this.filmCategory,this.movieName,this.image_pass,this.movieTime);

  List<Widget> listMovieSeats(DataSnapshot snapshot,DatabaseReference movieRef,DatabaseReference check,DatabaseReference refNotify) {

    List<Widget> finalList = new List();
    // List<RaisedButton> buttons = new List(47);
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
          // debugPrint(snapshot.value['seat1'].toString());
          int index = flag;
          if(snapshot.value['seat$flag']=="false"){
            Color buttonColor = Colors.grey;
            // int index = flag;

            booking(snapshot, movieRef, check,);
            list.add(
                new Container(
                  padding: new EdgeInsets.only(right:5,bottom: 5),
                  width: 30,
                  height: 30,
                  child: RaisedButton(
                    color: buttonColor,
                    onPressed: () {
                      // int index = list.indexOf(RaisedButton());
                      String key=snapshot.key;
                      // debugPrint(key);
                      // debugPrint(email);
                      // debugPrint("$index");
                      
                      movieRef.child("Movies").child(filmCategory).child(movieKey).child("Seats").child(key).child("seat$index").set(email);
                      //booking(snapshot, movieRef, check);
                      notfiy(refNotify, index, "Booked");
                    },
                  ),
                )
            );
          }else
            if(snapshot.value['seat$flag']==email){
              // debugPrint("$index");
              Color buttonColor = Colors.green;

              booking(snapshot, movieRef, check);

              list.add(
                  new Container(
                    padding: new EdgeInsets.only(right:5,bottom: 5),
                    width: 30,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () {
                        String key=snapshot.key;
                        
                        movieRef.child("Movies").child(filmCategory).child(movieKey).child("Seats").child(key).child("seat$index").set("false");
                        //booking(snapshot, movieRef, check);
                        notfiy(refNotify, index, "Canceled");
                      },
                      color: buttonColor,
                    ),
                  )
              );
          }else
            if(snapshot.value['seat$flag']!= "false"){

              // debugPrint("$index");
              //// debugPrint(snapshot.value['seat$flag'].toString());

              Color buttonColor = Colors.blue;
              list.add(
                  new Container(
                    padding: new EdgeInsets.only(right:5,bottom: 5),
                    width: 30,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () {
                        ErrorHint("This seat is already booked");
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


  void booking(DataSnapshot snapshot,DatabaseReference movieRef,DatabaseReference check){

    for(int i=1;i<=47;i++){
      if(snapshot.value['seat$i']==email){

        check.child("Booking_before").child(movieName).once().then((DataSnapshot data){
          setState(() {
            v=data.value;
          });
          if(v=="0"){

            //String key = movieRef.child("Bookings").child(email).push().key;
            
            movieRef.child("Bookings").child(email).child(movieName).child("MovieName").set(movieName).asStream();
            movieRef.child("Bookings").child(email).child(movieName).child("MovieImage").set(image_pass).asStream();
            movieRef.child("Bookings").child(email).child(movieName).child("MovieTime").set(movieTime).asStream();
            movieRef.child("Bookings").child(email).child(movieName).child("MovieCategory").set(filmCategory).asStream();
            check.child("Booking_before").child(movieName).set("1");

            //String key = refNotify.push().key;
            //refNotify.child("$i").child("notify").set(email+" booked this Movie: "+movieName);
            
          }else{
            
          }
        });

        break;

      }else if(i==47 && snapshot.value['seat47']=="false"){
        check.child("Booking_before").child(movieName).set("0");
        movieRef.child("Bookings").child(email).child(movieName).remove();

        //String key = refNotify.push().key;
        //refNotify.child("$i").child("notify").set(email+" canceled this Movie: "+movieName);

      }
    }

  }

  void notfiy(DatabaseReference refNotify,int seatNum,String state){

    String key = refNotify.push().key;
    refNotify.child(key).child("notify").set(email+" "+state+" seat num $seatNum"+" in this Movie: "+movieName);

  }


  final referenceDatabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {

    final movieRef=referenceDatabase.reference().child("Movies").child(filmCategory).child(movieKey).child("Seats");

    final check=referenceDatabase.reference().child(email) ;

    final ref=referenceDatabase.reference();

    final refNotify=referenceDatabase.reference().child("Notifications");

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber.shade300,
        title:new Row(
          children: [
            new Text(
              "Movie Seats: ",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            new Text(
              email,
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
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
                new Container(
                  child: new Image.asset("images/theater.png"),
                  width: 250,
                  height: 200,
                ),
               // new Container(
                //   padding: new EdgeInsets.fromLTRB(0, 0, 0, 10),
                //   child: new Text("Choice your Seat",style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                // ),
                new Flexible(child: new FirebaseAnimatedList(shrinkWrap: true,
                  query: movieRef, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: listMovieSeats(snapshot,ref,check,refNotify),
                    );
                  },
                )),
                new SingleChildScrollView(
                  padding: new EdgeInsets.only(top: 10),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Colors.green,
                              onPressed: () {true;},
                            ),
                          ),
                          new Container(
                            child: new Text("Booked for You"),
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
