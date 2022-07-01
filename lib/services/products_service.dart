import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;


class ProductsService extends ChangeNotifier{
  //final String baseUrl = 'flutter-varios-36cf0-default-rtdb.europe-west1.firebaseio.com';
  final String baseUrl =  'flutter-varios-36cf0-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];

  final storage = new FlutterSecureStorage();

//  Product? selectedProduct;  // puede ser nulo
  late Product selectProduct;  // es lo mismo que el anterior.
  File? newPictureFile;

  bool isLoading  =  true;
  bool isSaving   =   false;

  ProductsService() {
    this.loadProducts();
  }
  

  Future<List<Product>> loadProducts() async{
    this.isLoading= true;
    notifyListeners(); //avisamos que hay un cambio
    final url = Uri.https( baseUrl,  'products.json', {'auth': await storage.read(key:'token') ??'' } );    
    final resp =await http.get(url);
    
    final Map<String, dynamic> productsMap = json.decode( resp.body );
    
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id =  key;
      this.products.add(tempProduct);
    });
  
  this.isLoading=false;
  notifyListeners();  //avisamo se que hemos acabado

    
    return this.products;

  }

  Future saveOrCreateProduct( Product product ) async{
    isSaving =true;
    notifyListeners();

    if (product.id ==null){
        await this.createProduct(product);
    }
    else{
      await this.updateProduct(product);
    }

    isSaving= false;
    notifyListeners();


  }

  Future<String> updateProduct( Product product ) async{
    final url = Uri.https( baseUrl,  'products/${ product.id}.json', {'auth': await storage.read(key:'token') ??'' } );    
    final resp =await http.put(url , body: product.toJson( ) );
    final decodedData = resp.body;
    print(decodedData);


/*
    for (var i = 0; i < products.length; i++){
        if (products[i].id== product.id ){
            products[i] = product;
          continue;
        }
    }
    o 
    
    */
    final index =this.products.indexWhere((element) => element.id==product.id);
    this.products[index] = product;
   
    return product.id!;




  }


  Future<String> createProduct( Product product ) async{
    final url = Uri.https( baseUrl,  'products.json', {'auth': await storage.read(key:'token') ??'' } );    
    final resp =await http.post(url , body: product.toJson( ) );
    final decodedData = json.decode (resp.body );

    product.id = decodedData['name'];
   // print( decodedData);
    this.products.add(product);


    return product.id!;

  }  

  void updateSelectedProductImage( String path ){
      this.newPictureFile  = File.fromUri( Uri(path: path)  );
      this.selectProduct.picture = path;

      notifyListeners();

  }

  Future<String?> uploadImage( ) async {
      if (this.newPictureFile == null) return null;
      this.isSaving = true;

      notifyListeners();

      final url = Uri.parse('https://api.cloudinary.com/v1_1/drl1nmdwa/image/upload?upload_preset=hkogzrbp');

      final imageUploadRequest = http.MultipartRequest( 'POST',    url  );
      final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );
      imageUploadRequest.files.add( file );

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode!=200 && resp.statusCode!= 201 ){
        print("Error a la llamada");
        print( resp.body );
        return null;
      }
      final decodedData = json.decode( resp.body );
      this.newPictureFile = null;
//      print(resp.body);
      return decodedData['secure_url'];


  }

}