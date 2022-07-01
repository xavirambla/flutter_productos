import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';
import 'services/services.dart';


void main() => runApp(AppState());

class AppState extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ProductsService()),
        ChangeNotifierProvider(create: ( _ ) => AuthService()),

      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false      ,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
          'checking':  ( _ )     =>  const CheckAuthScreen(),

          'home' :    ( _ )     =>  const HomeScreen(),
          'product':  ( _ )     =>  const ProductScreen(),

          'login':    ( _ )     =>  const LoginScreen(),
          'register': ( _ )     =>  const RegisterScreen(),         
      },
    scaffoldMessengerKey: NotificationsService.messengerKey,
    theme: ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.grey[300],
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.indigo 

      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.indigo ,
        elevation: 0
      )
    ),

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
      ),
    );
  }
}