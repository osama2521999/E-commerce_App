import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Admin_notifications extends StatefulWidget {
  @override
  _Admin_notificationsState createState() => _Admin_notificationsState();
  
}

class _Admin_notificationsState extends State<Admin_notifications> {

  final referenceDatabase = FirebaseDatabase.instance;

  

  @override
  Widget build(BuildContext context) {
    
    final ref=referenceDatabase.reference().child("Notifications");

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber.shade300,
        title: Text("Notifications"),
      ),
      body: Container(
        color: Colors.amber,
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child:  new FirebaseAnimatedList(shrinkWrap: true,
                      query: ref, itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    return new ListTile(
                      trailing: new IconButton(
                        icon: new Icon(Icons.delete),
                        onPressed: () {
                          ref.child(snapshot.key).remove();
                        } ,
                      ),
                      subtitle:Column(
                        children: [
                          new Text(snapshot.value['notify']),
                          
                        ],
                      )
                    );

                  } ),
              ),
            ],
          ),
        

        ),
      ),
    );
  }
}