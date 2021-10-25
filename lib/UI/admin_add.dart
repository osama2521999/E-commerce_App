import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'admin.dart';

class Admin_Add extends StatefulWidget {
  @override
  _Admin_AddState createState() => _Admin_AddState();
}

class _Admin_AddState extends State<Admin_Add> {


  String F_title ;
  String F_description ;
  String Image_Name;
  String F_ImagePass;
  String F_time ;
  String Num_of_seats = "47";

  String moviesCategory;

  File image ;

  String p =null;

  bool buldingWait = false;



  final referenceDatabase = FirebaseDatabase.instance;

  

   addMovie(DatabaseReference movieRef)  async {
    if(F_ImagePass==null||F_time==null||F_description==null||F_title==null||moviesCategory==null){
      _wrongInput();
    }else{
      String key= movieRef.push().key;

       await  uploadImage(key);

       if(p !=null){
        movieRef.child(moviesCategory).child(key).child("Movie Title").set(F_title);
        movieRef.child(moviesCategory).child(key).child("Movie Description").set(F_description);

        //await uploadFile(key);
        movieRef.child(moviesCategory).child(key).child("Movie Image pass").set(p);


        movieRef.child(moviesCategory).child(key).child("Movie Time").set(F_time);
        movieRef.child(moviesCategory).child(key).child("Num of Seats").set(Num_of_seats);
        String seatsKey = movieRef.push().key;
        for(int i=1;i<=47;i++){
          movieRef.child(moviesCategory).child(key).child("Seats").child(seatsKey).child("seat$i").set("false");
        }
        _addDone();
        // this.setState(() {
        //   buldingWait=false;          
        // });
      }else{
      }
    }
  }

  gallery(BuildContext context) async{
    // var picked_image = await ImagePicker.pickImage(source: ImageSource.gallery);
    PickedFile picked_image = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      image=File(picked_image.path);
    });
    debugPrint("ssssssssss"+image.path);
    Navigator.of(context).pop();
  }
  camera(BuildContext context) async{
    // var picked_image = await ImagePicker.pickImage(source: ImageSource.camera);
    PickedFile picked_image = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      image=File(picked_image.path);
    });
    debugPrint(image.path);
    Navigator.of(context).pop();
  }

  Widget show_image(){
    if(image==null){
      return new Text("No Image Selected yet");
    }else{
      this.setState(() {
        F_ImagePass=image.path;
      });
      return new Image.file(
          image,width: 200,height: 200,
          alignment: Alignment.center,
      );
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text("Choice Image Place"),
          content: new SingleChildScrollView(
            child: new Column(
              children: [
                new Row(
                  children: [
                    new FlatButton(
                    onPressed:() =>  gallery(context),
                    child: new Text("Gallery ")
                    ),
                    Padding(padding: EdgeInsets.only(left: 100)),
                    new Icon(Icons.image),
                  ],
                ),         
                new Row(
                  children: [
                    new FlatButton(
                    onPressed: () => camera(context),
                    child: new Text("Camera")
                    ),
                    Padding(padding: EdgeInsets.only(left: 100)),
                    new Icon(Icons.camera_alt)
                  ],
                )
              ],
            ),
          ),
          actions: [
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text("Cancel")
            )
          ],
        );
      },
    );
  }

  Future<void> _wrongInput() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text("All fields are mandatory"),
          content: new Text("Failed Add"),
          actions: [
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text("Ok")
            )
          ],
        );
      },
    );
  }
  Future<void> _addDone() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title:  new Text("Done"),
          content: new Text("Adding Done Successfully"),
          actions: [
            new FlatButton(
                onPressed: () { 
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil("/Admin", (route) => false);
                  },
                child: new Text("Ok")
            )
          ],
        );
      },
    );
  }


  Future<void> uploadImage(String imagePass ) async {
    

    Reference reference = FirebaseStorage.instance.ref().child('images/$imagePass'); 
    await reference.putFile(image).whenComplete(() async{
      await reference.getDownloadURL().then((value) {
        setState(() {
          p=value;
        //  this.setState(() {
        //      buldingWait=true;        
        //   });
        //   debugPrint(buldingWait.toString());
        });
      });
    }); 

  }
  
  Widget wait(){
   
    if(buldingWait==true){
      return Center(
                  child: Column(
                    children: [
                      Text(
                        "Uploading",
                        style: TextStyle(fontSize: 20),
                      ),
                      CircularProgressIndicator(
                        //value: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    ],
                  ),
                
              );
    }else{
      return Container();
    }
    
  }

  @override
  Widget build(BuildContext context) {

    final movieRef=referenceDatabase.reference().child("Movies");
      //bool buldingWait = false;


    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber.shade300,
        title: new Text(
            "Add New Movie",
             style: new TextStyle(color: Colors.blue),
        ),
      ),
      body: new Container(
        color: Colors.amber,
        child: new Center(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                show_image(),

                

                new Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      dropdownColor: Colors.amber.shade700,
                      hint: Text("moviesCategory"),
                      value: moviesCategory,
                      items: <String>['Action','Comedy','Romantic',"Mix"].map((String value) {
                          return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                          );
                        }
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          moviesCategory=value;
                        });
                        debugPrint(moviesCategory);
                      },
                    ),
                  
                  )
                  ),
                  width: 200,
                  height: 70,
                ),

                new Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: new TextField(
                    decoration: new InputDecoration(hintText: "Enter Movie Title"),
                    onChanged: (value) => F_title=value,
                  ),
                  width: 200,
                ),
                new Container(
                  child: new TextField(
                    decoration: new InputDecoration(hintText: "Enter Movie Description"),
                    onChanged: (value) => F_description=value,
                  ),
                  width: 200,
                ),
              
                new Container(
                  child: new TextField(
                    decoration: new InputDecoration(hintText: "Enter Movie Time"),
                    onChanged: (value) => F_time=value,
                  ),
                  width: 200,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RaisedButton(
                        onPressed:() {
                            //buldingWait=true;
                          addMovie(movieRef);
                          },
                        child: new Text("Add"),
                        color: Colors.blue,
                      ),
                    ),
                    new Container(
                      padding: new EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: RaisedButton(
                        onPressed:() => _showMyDialog(),
                        child: new Text("Choice Movie Image"),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                wait()
              //   buldingWait? Center(
              //     child: Column(
              //       children: [
              //         Text(
              //           "Uploading",
              //           style: TextStyle(fontSize: 20),
              //         ),
              //         CircularProgressIndicator(
              //           //value: 1,
              //           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              //         )
              //       ],
              //     ),
                
              // )
              // :Container(
              // )

              ],
              
            ),
          )
        ),
      ),
    );
  }


}
