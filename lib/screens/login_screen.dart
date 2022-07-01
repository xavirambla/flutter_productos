import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/ui.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
   const LoginScreen ({Key? key}) : super(key:  key);

   @override
   Widget build (BuildContext context){  
      return  Scaffold(
         body: AuthBackground(
           child: SingleChildScrollView(   // listview o singlechildScrolView
             child: Column(
               children: [
                 const SizedBox(height: 250,),
                 CardContainer(
                   child: Column(
                     children: [
                       const SizedBox(height: 10,),
                       Text('Login', style: Theme.of(context).textTheme.headline4),
                       const SizedBox(height: 30,),
                      
                      ChangeNotifierProvider( 
                        create:  ( _ ) => LoginFormProvider( ),
                        child: _LoginForm() ,),
                      
                      
                     ],
                   )
                 ),
                   const SizedBox(height: 50,),
                   TextButton(
                     onPressed: (){
                       Navigator.pushReplacementNamed(context, 'register');
                     },
                     style: ButtonStyle(
                       overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                       shape: MaterialStateProperty.all( StadiumBorder() )
                       

                     ),
                     child: const Text("Crear una nueva cuenta", style: TextStyle(fontSize: 18, color: Colors.black87)) ,
                     ),
                   const SizedBox(height: 30,),                   

               ],
             )
           )

         )
      );
   }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(        
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction, // se valida cuando acaba la interacción del usuario        

        child: Column(
          children: [
            TextFormField( 
              autocorrect: false , //no correija las faltas de ortografia
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration( 
                hintText: 'xavi@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_sharp,
              ),             
              onChanged: ( value ) {
                loginForm.email = value;
              },
              validator: ( value ){

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);                
                return regExp.hasMatch(value ?? '')  // si es nulo, que devuelva un vació
                  ? null
                  : 'El valor ingresado no es un correo';
                
              }, 
            ),
            const SizedBox(height: 30,),

            TextFormField( 
              autocorrect: false , //no correija las faltas de ortografia
              obscureText: true,  // para que no se vea el password
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outlined,                
              ),            
              onChanged: ( value )=> loginForm.password  = value,  
              validator: ( value ){
                if ( value!= null && value.length>=6)     return null;
                return 'Contraseña debe ser de 6 caracteres.';



              },
            ),
            const SizedBox(height: 30,),

            MaterialButton(
              shape:  RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
                child:  Text(
                  loginForm.isLoading
                    ? "Espere"
                    : "Ingresar" , 
                  style: const  TextStyle(color: Colors.white),)

              ),

      //si es false , no hay acción en onpressed,
      //en caso de true se activa la función
                onPressed: loginForm.isLoading? null :  () async {
                FocusScope.of(context).unfocus(); // quita el teclado
                

                if (! loginForm.isValidForm() )      return ;
                
                loginForm.isLoading = true;

                final authService = Provider.of<AuthService>(context, listen: false);
                final String? errorMessage = await authService.login( loginForm.email, loginForm.password);
                
                
                if  (errorMessage==null){                
                  Navigator.pushReplacementNamed(context, 'home');  
                }
                else {
                    print(errorMessage) ;
                    NotificationsService.showSnackbar(errorMessage);
                    loginForm.isLoading = false;
                }                  
                
              }
              )


          ],)
        
      ),
      
    );
  }
}