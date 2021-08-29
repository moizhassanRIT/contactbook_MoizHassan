import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';




class AudioRecorder{
  FlutterSoundRecorder? audioRecorder;
  String pathToSaveAudio = '/data/user/0/com.example.contactbook/cache/audio.aac';
  bool get isRecording => audioRecorder!.isRecording;

  Future init() async {
    audioRecorder = FlutterSoundRecorder();
    await audioRecorder!.openAudioSession();

  }

  Future record() async{
    await audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future stop() async{
    await audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async{
    if(audioRecorder!.isStopped){
      await record();
    }
    else{
      await stop();
    }
  }

  void dispose() {
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
  }

}