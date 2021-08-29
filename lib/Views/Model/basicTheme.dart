import 'package:flutter/material.dart';

ThemeData basicTheme(String themeMode){

  final ThemeData base = ThemeData(primarySwatch: Colors.blue);

  if(themeMode != 'dark')
  return base.copyWith(
    //textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.white60,
    backgroundColor: Colors.white60,
    buttonColor: Colors.blueGrey.shade700,
    disabledColor: Colors.grey,
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
    ),
  );

    return base.copyWith(
      //textTheme: _basicTextTheme(base.textTheme),
      primaryColor: Colors.yellowAccent,
      scaffoldBackgroundColor: Colors.black,
      accentColor: Colors.black,
      backgroundColor: Colors.black,
      buttonColor: Colors.white,
      disabledColor: Colors.grey,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
      ),
    );


}