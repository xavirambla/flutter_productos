import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

  class CheckAuthScreen extends StatelessWidget {
     const CheckAuthScreen ({Key? key}) : super(key:  key);
  
     @override
     Widget build (BuildContext context){  
          final authService = Provider.of<AuthService>(context, listen: false);

        return Scaffold(
           body: Center(  
              child: FutureBuilder(
                future: authService.readToken(),                
                builder: (BuildContext context, AsyncSnapshot<String> snapshot)
                {
                  if ( !snapshot.hasData){

                  //no puedo lanzarlo directamente pq tengo que devolver un widget. Asi que creo una tarea que se ejecutará cuando acabe el proceso
                  // Este Microtask se ejecuta tan rápido puedas pero después de generar este widget que te devuelvo
                  Future.microtask(() {
//                    Navigator.of(context).pushReplacementNamed( 'login' ); 
                    //navegación manual
                    Navigator.pushReplacement( context, PageRouteBuilder(
                      pageBuilder: (_,__ , ___ )=> const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0)
                      ),
                    );    
                });

                  }

                 else{

                  //no puedo lanzarlo directamente pq tengo que devolver un widget. Asi que creo una tarea que se ejecutará cuando acabe el proceso
                  
                  Future.microtask(() {
//                    Navigator.of(context).pushReplacementNamed( 'login' ); 
                    //navegación manual
                    Navigator.pushReplacement( context, PageRouteBuilder(
                      pageBuilder: (_,__ , ___ )=> const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0)
                      ),
                    );    
                });

                  }




                  return Container();

                }
                )
              ),
        );
     }
  }
  
