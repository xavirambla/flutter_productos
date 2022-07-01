import 'package:flutter/material.dart';

class NotificationsService{
  
  //mantiene la referencia a mi material app
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>() ;

  static showSnackbar( String message ){
    final snackBar = new SnackBar(
      content:  Text(message, style: const  TextStyle( color: Colors.white, fontSize: 20)),
      );
      messengerKey.currentState!.showSnackBar(snackBar);
     }



}