
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MyreservedMovies.dart';
import 'UserMovieSeats.dart';

class MoreDetails extends StatefulWidget {

  String movieName;
  String image_pass;
  String movieDescription;
  String movieTime;
  String Email;

  String filmKey;

  String filmCategory;

  MoreDetails(this.Email,this.movieName,this.movieDescription,this.movieTime,this.image_pass,this.filmKey,this.filmCategory);

  @override
  _MoreDetailsState createState() => _MoreDetailsState(Email,movieName,movieDescription,movieTime,image_pass,filmKey,filmCategory);
}

class _MoreDetailsState extends State<MoreDetails> {

  String email;

  String movieName;
  String image_pass;
  String movieDescription;
  String movieTime;

  String filmKey;

  String filmCategory;

  _MoreDetailsState(this.email,this.movieName,this.movieDescription,this.movieTime,this.image_pass,this.filmKey,this.filmCategory);

  String v;



  final referenceDatabase = FirebaseDatabase.instance;

  Future<void> _showMyDialog(String Film_name , String Booking_time) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text(Film_name),
          content: new SingleChildScrollView(
            child: new Text(Film_name+" is Booking Successfully in "+ Booking_time),
          ),
          actions: [
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text("Ok")
            )
          ],
        );
      },
    );
  }

  Future<void> _showBookingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text("Can't",style: new TextStyle(color: Colors.red),),
          content: new SingleChildScrollView(
            child: new Text("You already Booked movie before in this time\nYou can go to remove him then book another"),
          ),
          actions: [
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text("Ok")
            )
          ],
        );
      },
    );
  }



  void ch_N(DatabaseReference ref,DatabaseReference checking,String t){
    checking.child("MidNight").child("Booking_before").once().then((DataSnapshot data){
      setState(() {
        v=data.value;
      });
      if(v=="0"){

        String key = ref.child("Bookings").child(t).child("Users").child(email).push().key;
        debugPrint(key);
        ref.child("Bookings").child(t).child("Users").child(email).child(key).child("MovieName").set(movieName).asStream();
        ref.child("Bookings").child(t).child("Users").child(email).child(key).child("MovieImage").set(image_pass).asStream();

        _showMyDialog(movieName, "MidNight");
        checking.child("MidNight").child("Booking_before").set("1");
        debugPrint(v);
      }else{
        _showBookingDialog();
        debugPrint(v);
        debugPrint("cant add");
      }
    });
  }
  
  void ch_M(DatabaseReference checking){

    checking.child("Booking_before").child(movieName).once().then((DataSnapshot data){

      setState(() {
        v=data.value;
      });
      if(v=="0"||v=="1"){

      }else{
        checking.child("Booking_before").child(movieName).set("0");
      }

    });
    

        // String key = ref.child("Bookings").child(email).push().key;
        // debugPrint(key);
        // ref.child("Bookings").child(email).child(key).child("MovieName").set(movieName).asStream();
        // ref.child("Bookings").child(email).child(key).child("MovieImage").set(image_pass).asStream();
        // ref.child("Bookings").child(email).child(key).child("MovieTime").set(movieTime).asStream();
        // ref.child("Bookings").child(email).child(key).child("MovieCategory").set(filmCategory).asStream();

        
        

     
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();

    // final ref_user_n=referenceDatabase.reference().child(email) ;
    // final ref_user_m=referenceDatabase.reference().child(email) ;

    final check=referenceDatabase.reference().child(email) ;

    final movie=referenceDatabase.reference().child("Movies") ;

    //File image = File(image_pass);

    return Scaffold(
      appBar: new AppBar(
        title:new Row(
          children: [
            new Text(
              "Film: ",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            new Text(
              movieName,
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
        actions: [
          new IconButton(
            icon:Icon( Icons.save),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReservedMovies(email),) );
            },
            tooltip: "Your reserved Movies" ,
          )
        ],
        backgroundColor: Colors.amber.shade300,
      ),
      body: new Container(
        color: Colors.amber,
        child: new Center(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  width: 300,
                  height: 300,
                 // child: new Image.asset(image_pass),
                  //child: new Image.file(image),
                  child: new Image.network(image_pass),
                  
                ),
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.fromLTRB(8, 2, 0, 0),
                    child: new Text("Movie Name:",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                ),
                new Text(movieName, style: new TextStyle(fontSize: 16,fontStyle: FontStyle.italic)),
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.fromLTRB(8, 2, 0, 0),
                    child: new Text("Movie Description:",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                ),
                new Text(movieDescription,style: new TextStyle(fontSize: 16,fontStyle: FontStyle.italic)),
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.fromLTRB(8, 2, 0, 0),
                    child: new Text("Movie Time:",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                ),
                new Text(movieTime,style: new TextStyle(fontSize: 16,fontStyle: FontStyle.italic)),
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.fromLTRB(8, 2, 0, 0),
                    child:new Text("Booking in :",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                ),
                new Container(
                  padding: new EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: new RaisedButton(
                    child: new Text("choice your seats",style: new TextStyle(color: Colors.blue),),
                    onPressed: () {
                       ch_M(check);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserMovieSeats(email,filmKey,filmCategory,movieName,image_pass,movieTime),));

                      },
                    color: Colors.white,
                  ),
                ),
              
               ],
            ),
          ),
        ),
      ),

    );
  }
}
