import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'Views/AuthenticationScreen.dart';
import 'Views/Model/basicTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Firebase Template',
      theme: basicTheme('light'),
      //darkTheme: basicTheme('dark'),
      //         DesktopBP |MobileBP| MobileScreen | TabletScreen      | DesktopScreen
      home: AuthenticationScreen(),
      //
    );
  }
}
