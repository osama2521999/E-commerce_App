import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AdminMovieSeats.dart';

class Admin_MoreDetails extends StatefulWidget {
  @override

  String movieTitle;
  String movieDescription;
  String movieTime;
  String imagePass;

  String movieKey;

  String filmCategory;

  Admin_MoreDetails(this.movieTitle,this.movieDescription,this.movieTime,this.imagePass,this.movieKey,this.filmCategory);

  _Admin_MoreDetailsState createState() => _Admin_MoreDetailsState(movieTitle,movieDescription,movieTime,imagePass,movieKey,filmCategory);
}

class _Admin_MoreDetailsState extends State<Admin_MoreDetails> {


  String movieTitle;
  String movieDescription;
  String movieTime;
  String imagePass;

  String movieKey;

  String filmCategory;


  _Admin_MoreDetailsState(this.movieTitle,this.movieDescription,this.movieTime,this.imagePass,this.movieKey,this.filmCategory);

  
  //File image;

  Widget showImage(String imagePass){

    if(imagePass==null){
      return new Text("No Image Selected");
    }else{
      // image=File(imagePass);
      // return new Image.file(image);
      return new Image.network(imagePass);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:new Row(
          children: [
            new Text(
              "Movie: ",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            new Text(
              movieTitle,
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber.shade300,
      ),
      body: new Container(
        color: Colors.amber,
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                width: 300,
                height: 300,
                child: showImage(imagePass),
              ),
              new Container(
                  alignment: Alignment.centerLeft,
                  padding: new EdgeInsets.fromLTRB(8, 2, 0, 0),
                  child: new Text("Movie Name:",style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
              ),
              new Text(movieTitle, style: new TextStyle(fontSize: 16,fontStyle: FontStyle.italic)),
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
                padding: new EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: new RaisedButton(
                  child: new Text("View Movie Seats",style: new TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMovieSeats(movieKey,filmCategory)));
                  },
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
