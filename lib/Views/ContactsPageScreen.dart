import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactbook/Controller/Controller.dart';
import 'package:contactbook/Views/AddContactsScreen.dart';
import 'package:contactbook/Views/AuthenticationScreen.dart';
import 'package:contactbook/Views/Model/AuthenticationService.dart';
import 'package:contactbook/Views/Widgets/AudioPlayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'EditContactScreen.dart';


class ContactsPageScreen extends StatefulWidget {
  const ContactsPageScreen({Key? key}) : super(key: key);

  @override
  _ContactsPageScreenState createState() => _ContactsPageScreenState();
}

class _ContactsPageScreenState extends State<ContactsPageScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference contactlist = FirebaseFirestore.instance
      .collection('contacts')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('contactlist');

  final player = AudioPlayer();


  @override
  void initState(){
    super.initState();
    player.init();
  }

  @override
  void dispose(){
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Screen'),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthenticationScreen(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('contacts')
              .doc(user!.uid)
              .collection('contactlist')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Container(
                      margin: EdgeInsets.all(7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      //height: MediaQuery.of(context).size.height * 0.12,
                      color: Colors.grey[100],
                      child: ListTile(
                        //isThreeLine: true,
                        subtitle: Container(
                          child: Row(
                            children: [
                              Text(document['designation']),
                              IconButton(onPressed: ()async {
                                //player.dispose();
                                //player.init();
                                player.pathToReadAudio = document['audiourl'];
                                final isRecording = await player.togglePlaying(whenFinished: (){},Path: document['audiourl'].toString());
                              }, icon: Icon(Icons.play_arrow))
                            ],
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 40,
                          child: ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(document['imageurl']),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                            '${document['firstname'] + ' ' + document['lastname']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  //print(document.get('firstname'));
                                  String fn = document['firstname'].toString();
                                   String ln = document['lastname'].toString();
                                   String designation = document['designation'].toString();
                                   String phonenum = document['phonenum'].toString();
                                   String imageURL = document['imageurl'].toString();
                                   String docID = document.id.toString();
                                   DocumentReference docREF = document.reference;


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) { return EditContactScreen(fn,ln,designation,phonenum,imageURL,docID);},
                                      ));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                await FirebaseStorage.instance
                                    .refFromURL(document['imageurl'])
                                    .delete()
                                    .then((value) => print('Image Deleted'));
                                await document.reference
                                    .delete()
                                    .then((value) => print('User Deleted'));
                              },
                            ),
                          ],
                        ),
                        onTap: () => Controller()
                            .launchPhoneCaller(document['phonenum']),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddContactsScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
