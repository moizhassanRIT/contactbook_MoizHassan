

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService{
  String? uid = "";

  DatabaseService({this.uid});

  final CollectionReference contactsRef = FirebaseFirestore.instance.collection('contacts');

  Future<void> createInitialCollection() async{
    print(uid);
     try{
       contactsRef.add({
         'uid':uid
       });

     }catch(e){
       print(e);
     }
  }

  Future<String> uploadImage(String imagePath) async{
    File image  = File(imagePath);
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${uid}/${imagePath}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() {
      print('File Uploaded!');
      return storageReference.getDownloadURL();
    });
    return "Not Uploaded";

  }

  Future<String> uploadAudio(String audioPath) async{
    File audio = File(audioPath);
    Reference storageReference = FirebaseStorage.instance.ref().child('audio/${uid}/${audioPath}');
    UploadTask uploadTask = storageReference.putFile(audio);
    await uploadTask.whenComplete(() {
      print('File Uploaded!');
      return storageReference.getDownloadURL();
    });
    return "Not Uploaded";

  }

  Future<void> updateContact(String docId,String firstname,String lastname,String designation,String phonenum) async{

    DocumentReference docRef = contactsRef.doc(uid).collection('contactlist').doc(docId);

    // Uploading Contact Info with Image URL to firestore collection.
    try{
      docRef.update({
        'firstname':firstname,
        'lastname':lastname,
        'designation':designation,
        'phonenum':phonenum,
      });

    }catch(e){
      print(e);

    }
  }

  Future<void> updateContactwithImage(String docId,String firstname,String lastname,String designation,String phonenum,String imagePath) async {
    DocumentReference docRef = contactsRef.doc(uid).collection('contactlist').doc(docId);

    String imageUrl = "No URL";
    File image  = File(imagePath);
    String imageName = imagePath.substring(imagePath.lastIndexOf('/'),);
    /// Uploading Image to Firebase storage
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${uid}/${imageName}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
      print('File Uploaded!');
      imageUrl = await storageReference.getDownloadURL();
    });

    try{
      docRef.update({
        'firstname':firstname,
        'lastname':lastname,
        'designation':designation,
        'phonenum':phonenum,
        'imageurl':imageUrl,
      });

    }catch(e){
      print(e);

    }



  }
  
  Future<void> createContact(String firstname,String lastname,String designation,String phonenum,String imagePath,String audioPath) async{
    String imageUrl = "No URL";
    File image  = File(imagePath);
    String imageName = imagePath.substring(imagePath.lastIndexOf('/'),);
    /// Uploading Image to Firebase storage
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${uid}/${imageName}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
      print('File Uploaded!');
      imageUrl = await storageReference.getDownloadURL();
    });
    /// uploading Audio File
    //String audioName = imagePath.substring(imagePath.lastIndexOf('/'),);
    String audioUrl = "No URL";
    File audio  = File(audioPath);
    String audioName = '${phonenum+firstname+'.aac'}';
    Reference AudiostorageReference = FirebaseStorage.instance.ref().child('audio/${uid}/${audioName}');
    UploadTask audiouploadTask = AudiostorageReference.putFile(audio);
    await audiouploadTask.whenComplete(() async {
      print('File Uploaded!');
      audioUrl = await AudiostorageReference.getDownloadURL();
    });


    // Uploading Contact Info with Image URL to firestore collection.
    try{
      contactsRef.doc(uid).collection('contactlist').add({
        'firstname':firstname,
        'lastname':lastname,
        'designation':designation,
        'phonenum':phonenum,
        'imageurl':imageUrl,
        'audiourl':audioUrl
      });
      
    }catch(e){
      print(e);
      
    }
    
  }

}