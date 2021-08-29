import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayer{


  FlutterSoundPlayer? audioPlayer;
  //String pathToSaveAudio = '/data/user/0/com.example.contactbook/cache/audio.aac';
  bool get isStopped => audioPlayer!.isStopped;
  //String pathToReadAudio = '/data/user/0/com.example.contactbook/cache/audio.aac' ;
  String pathToReadAudio = 'https://firebasestorage.googleapis.com/v0/b/contactbook-c2f36.appspot.com/o/audio%2FOFNTKuRR6PUBLxgFmyRZR7ANc1F3%2Fsample3.aac?alt=media&token=41e33333-2223-4c26-9252-805cd1bccad3';
  Future init() async {
    audioPlayer = FlutterSoundPlayer();
    print('opening...');
    await audioPlayer!.openAudioSession();
    print('opened.');

  }

  Future play(VoidCallback whenFinished,String Path) async{
    print('Print start');
    await audioPlayer!.startPlayer(fromURI: Path,whenFinished: whenFinished);
    print('done');

  }

  Future stop() async{
    await audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished,required String Path}) async{
    if(audioPlayer!.isStopped){
      await play(whenFinished,Path);
    }
    else{
      await stop();
    }
  }

  void dispose() {
    audioPlayer!.closeAudioSession();
    audioPlayer = null;
  }

}