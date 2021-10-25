import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservedMovies extends StatefulWidget {

  ReservedMovies(this.Email);
  String Email;

  




  @override
  _ReservedMoviesState createState() => _ReservedMoviesState(Email);
}

class _ReservedMoviesState extends State<ReservedMovies> {

  String email;
  _ReservedMoviesState(this.email);

  String Time="";

  DatabaseReference _ref1 ;
  //DatabaseReference _ref2 ;

  final referenceDatabase = FirebaseDatabase.instance;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase();
    _ref1=database.reference().child("Bookings").child(email);
    // _ref2=database.reference().child("Bookings").child("MidMorning").child("Users").child(email);
    super.initState();
  }

  String data(DataSnapshot snapshot){

    String test = snapshot.value['MovieName'];


    if(test==null){
      //debugPrint(snapshot.value['MovieName']+"sssssssssss");
      // return snapshot.value['MovieName'];
      return "No Movies Saved";
    }else{
      //debugPrint(snapshot.value['MovieName']+"aaaaaaa");
      return snapshot.value['MovieName'];
      // return "No Movies Saved";
    }
  }

  String time(DataSnapshot snapshot){

    String test = snapshot.value['MovieTime'];


    if(test==null){
      return "No Movies Saved";
    }else{
        Time=snapshot.value['MovieTime'];
      return snapshot.value['MovieTime'];
    }
  }


  String image(DataSnapshot snapshot){

    String test = snapshot.value['MovieImage']/*.value['MovieImage']*/;

    if(test==null){
      //debugPrint(test+"TTTTTt");
      return "No Movies Saved";
    }else{
     // debugPrint(test+"GGGGGg");
      return snapshot.value['MovieImage']/*.value['MovieImage']*/;
    }

  }

  @override
  Widget build(BuildContext context) {
    final ref_user=referenceDatabase.reference();
    return Scaffold(
      appBar: new AppBar(
        title:new Row(
          children: [
            new Text(
              email,
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            ),
            new Text(
                " Reserved Films",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber.shade300,
      ),
      body:new Container(
        color: Colors.amber,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                  alignment: Alignment.topLeft,
                  padding: new EdgeInsets.fromLTRB(8, 2, 0, 5),
                  child: new Text(Time+" Party",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
              ),
              Flexible(
                  child:  new FirebaseAnimatedList(shrinkWrap: true,
                      query: _ref1, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    return new ListTile(
                    
                      subtitle:Column(
                        children: [
                          new Text(data(snapshot)),
                          new Text(time(snapshot)),
                          new Container(
                            //child: new Image.asset(image(snapshot)),
                            child: new Image.network(image(snapshot)),
                            height: 200,
                            width: 200,
                          ),
                        ],
                      )
                    );

                  } ),
              ),
    
            ],
          ),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
          items:  [
            new BottomNavigationBarItem(icon: new Icon(Icons.sentiment_satisfied),backgroundColor:Colors.blue,title: new Text("We hope that come in time ")),
            new BottomNavigationBarItem(icon: new Icon(Icons.sentiment_very_satisfied),backgroundColor: Colors.blue,title: new Text("Enjoy $email")),

          ],
          unselectedItemColor: Colors.blue ,
          backgroundColor: Colors.amber.shade300 ,

      ),

    );
  }
}
