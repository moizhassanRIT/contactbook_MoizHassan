import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import 'AudioRecorder.dart';

class NewStopWatch extends StatefulWidget {
  @override
  _NewStopWatchState createState() => _NewStopWatchState();
}

class _NewStopWatchState extends State<NewStopWatch> {
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;

  bool recording = false;
  Icon recorderIcon = Icon(Icons.mic);

  String elapsedTime = '';

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

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: recorderIcon,
            onPressed: () async {
              final isRecording = await rec.toggleRecording();
              if (recordState == 'Record') {
                startWatch();
                setState(() {
                  recordState = 'Stop';
                  recorderIcon = Icon(Icons.stop);
                });
              } else {
                stopWatch();
                setState(() {
                  recordState = 'Record';
                  recorderIcon = Icon(Icons.mic);
                });
                //DatabaseService(uid: user!.uid).uploadAudio('/data/user/0/com.example.contactbook/cache/audio.aac');
              }
            },
          ),
          Container(
            child: Text(elapsedTime, style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),




    );
  }

  startOrStop() {
    if (startStop) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
