import 'dart:io';

import 'package:contactbook/Views/Model/DatabaseService.dart';
import 'package:contactbook/Views/Widgets/AudioRecorder.dart';
import 'package:contactbook/Views/Widgets/NewStopWatch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Widgets/temp_file.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({Key? key}) : super(key: key);

  @override
  _AddContactsScreenState createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _desig = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  var displayImage = Image.asset('assets/images/person.png');
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
  void initState() {
    var status = Permission.microphone.request();
    status.then((stat) {
      if (stat != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    });
    var statu = Permission.manageExternalStorage.request();
    statu.then((stat) {
      if (stat != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    });

    super.initState();
    rec.init();

    // tempFile(suffix: '.mp3').then((path) {
    //   recordingFile = path;
    //   track = Track(trackPath: recordingFile);
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Contacts'),
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
                        image =
                            await _picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          displayImage = Image.file(File(image!.path));
                        });
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    IconButton(
                      onPressed: () async {
                        image = await _picker.pickImage(
                            source: ImageSource.gallery);
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
              Container(
                child: NewStopWatch(),
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
                    await DatabaseService(uid: user!.uid).createContact(
                        _fname.text.trim(),
                        _lname.text.trim(),
                        _desig.text.trim(),
                        _phone.text.trim(),
                        image!.path,
                        '/data/user/0/com.example.contactbook/cache/audio.aac');
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
