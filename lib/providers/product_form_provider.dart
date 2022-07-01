import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';


// en el login se trabaja de una manera, aquí de una manera distinta.
// las dos son válidas
class ProductFormProvider  extends ChangeNotifier{

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Product product;

  ProductFormProvider(this.product );


  bool isValidForm(){
    print( product.name);
    print(product.price);
    print(product.available);
    
    return formKey.currentState?.validate()?? false;
  }


 updateAvailability (bool value){
   print (value   );
   this.product.available = value;
   notifyListeners();
 }

}