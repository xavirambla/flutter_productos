import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AuthService extends ChangeNotifier{
  final String _baseUrl='identitytoolkit.googleapis.com';
  final String _firebaseToken ='AIzaSyACe8C2fapO0rZEuiiYY9X2k-ymP-2pE64'; // token del api de firebase
  final storage =new FlutterSecureStorage();  // encripta los datos que almacene


  Future<String?> createUser(String email, String password) async{
    final Map<String, dynamic> authData ={
      'email':email,
      'password': password,
      'returnSecureToken': true   // para guardar el token para poder realizar operativa
      
    };

    final url = Uri.https(_baseUrl,'/v1/accounts:signUp', { 'key' : _firebaseToken });

    final resp = await http.post( url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );
   // print( decodedResp );
    if ( decodedResp.containsKey('idToken')){
      await storage.write(key: 'token', value: decodedResp['idToken'] );
      return null;
    }
    else{
      return decodedResp['error']['message'];
    }
    
  }


  Future<String?> login(String email, String password) async{
    final Map<String, dynamic> authData ={
      'email':email,
      'password': password,
      'returnSecureToken': true   // para guardar el token para poder realizar operativa      
    };

    final url = Uri.https(_baseUrl,'/v1/accounts:signInWithPassword', { 'key' : _firebaseToken });

    final resp = await http.post( url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );
    //print( decodedResp );

    
    if ( decodedResp.containsKey('idToken')){
      
      await storage.write(key: 'token', value: decodedResp['idToken'] );

      return null;
    }
    else{
      return decodedResp['error']['message'];
    }
    
    
  }  



  Future logout() async{
    await storage.delete(key: 'token');
    return ;
  }


  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';  // o me devuelve el valor o un string vacío
  }

}