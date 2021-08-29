import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactbook/Views/Model/DatabaseService.dart';
import 'package:contactbook/Views/Widgets/AudioRecorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


import 'Widgets/temp_file.dart';

class EditContactScreen extends StatefulWidget {
  //const EditContactScreen({Key? key}) : super(key: key);

  String fname="";
  String lname="";
  String designation = "";
  String phonenum = "";
  String imageUrl = "";
  String docID="";

  //String audioUrl = "";
  EditContactScreen(this.fname,this.lname, this.designation, this.phonenum, this.imageUrl,this.docID);


  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _desig = TextEditingController();



  User? user = FirebaseAuth.instance.currentUser;
  var displayImage = Image.network('assets/images/person.png');
  XFile? image;

  ImagePicker _picker = ImagePicker();
  FlutterSoundRecorder? flutterSound;
  bool recording = false;
  Icon recorderIcon = Icon(Icons.mic);

  late Track track;
  String recordingFile = "";

  final rec = AudioRecorder();
  String recordState = 'Record';



  @override
  void initState(){
    var status = Permission.microphone.request();
    status.then((stat) {
      if (stat != PermissionStatus.granted) {
        throw RecordingPermissionException(
            'Microphone permission not granted');
      }
    });
    var statu = Permission.manageExternalStorage.request();
    statu.then((stat) {
      if (stat != PermissionStatus.granted) {
        throw RecordingPermissionException(
            'Microphone permission not granted');
      }
    });
    super.initState();
    rec.init();
    print("Assigning..");
    _fname..text = widget.fname;
    _lname..text = widget.lname;
    _phone..text = widget.phonenum;
    _desig..text = widget.designation;
    displayImage = Image.network(widget.imageUrl);




  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Contacts'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: CircleAvatar(
                  child: ClipOval(
                    child: displayImage,
                  ),
                  radius: 70,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        image = await _picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          displayImage = Image.file(File(image!.path));
                        });
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    IconButton(
                      onPressed: () async{
                        image = await _picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          displayImage = Image.file(File(image!.path));
                          print(image!.path);
                        });
                        // print(image!.path);
                      },
                      icon: Icon(Icons.image),
                    )
                  ],
                ),
              ),
              //SoundRecorderUI(track),
              Container(
                child: ElevatedButton(
                  child: Text('${recordState}'),
                  onPressed: () async{
                    final isRecording = await rec.toggleRecording();
                    if(recordState == 'Record'){
                      setState(() {
                        recordState = 'Stop';
                      });
                    }
                    else{
                      setState(() {
                        recordState = 'Record';
                      });
                      //DatabaseService(uid: user!.uid).uploadAudio('/data/user/0/com.example.contactbook/cache/audio.aac');
                    }
                  },
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter the First Name',
                    labelText: 'First Name',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  controller: _fname,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter the Last Name',
                    labelText: 'Last Name',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  controller: _lname,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone number',
                    labelText: 'Phone Number',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  controller: _phone,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter the Designation',
                    labelText: 'Designation',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  controller: _desig,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {

                    if(image == null){
                      await DatabaseService(uid: user!.uid).updateContact(widget.docID,
                        _fname.text.trim(),
                        _lname.text.trim(),
                        _desig.text.trim(),
                        _phone.text.trim(),);
                    }
                    else{

                      await DatabaseService(uid: user!.uid).updateContactwithImage(
                          widget.docID,
                          _fname.text.trim(),
                          _lname.text.trim(),
                          _desig.text.trim(),
                          _phone.text.trim(),
                          image!.path);


                    }
                    Navigator.pop(context);
                  },
                  child: Text("Save Contact"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
