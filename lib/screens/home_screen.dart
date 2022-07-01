import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
   const HomeScreen ({Key? key}) : super(key:  key);

   @override
   Widget build (BuildContext context){  
     final productsService = Provider.of<ProductsService>(context);
     final authService     = Provider.of<AuthService>(context, listen: false);
     
    //mientras cargamos los datos, mostramos esta página.
     if(productsService.isLoading) return LoadingScreen();
      final productos = productsService.products;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          leading: IconButton(
            icon: const  Icon (Icons.login_outlined),
            onPressed: (){
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            ),
          ),
          body: ListView.builder(  // es perezoso, solo muestra los de pantalla y se van pidiendo. Si los tienes todos entonces sin builder
            itemCount: productos.length,
            itemBuilder: ( BuildContext context, int index) => GestureDetector(
              child: ProductCard( product: productos[index] ),
              onTap: (){
                // hacemos un copy pq no queremos que se modifique el objeto si se modifica.
                productsService.selectProduct = productsService.products[index].copy();
                Navigator.pushNamed(context, 'product');
              },
              ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon (Icons.add),
            onPressed: (){
              productsService.selectProduct = new Product(
                available: false , 
                price:0 , 
                name:'');
              Navigator.pushNamed(context,'product');
            },
            ),
            
      );
   }
}