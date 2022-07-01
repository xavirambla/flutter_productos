import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {

   const ProductScreen ({Key? key}) : super(key:  key);

   @override
   Widget build (BuildContext context){  
     final productsServices = Provider.of<ProductsService>(context);

// se hace esto pq la camara esta fuera del formulario
      return  ChangeNotifierProvider(
        create: ( _ ) => ProductFormProvider(productsServices.selectProduct ),
        child: _ProductScreenBody(productsServices: productsServices,)
        );
   }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsServices,
  }) : super(key: key);

  final ProductsService productsServices;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
       body: SingleChildScrollView(
         // cuando hago scroll oculta el teclado. comenta que no es recomendable pq es muy agresivo
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
         child: Column(
           children: [
             Stack(
               children: [
                 ProductImage( url: productsServices.selectProduct.picture),
                 Positioned(
                   top: 60,
                   left:20,
                   child: IconButton(
                     onPressed: () => Navigator.of(context).pop(),
                     icon: const Icon( Icons.arrow_back_ios_new, color: Colors.white,)
                   )
                   ),
                 Positioned(
                   top: 60,
                   right:20,
                   child: IconButton(
                     onPressed: ()  async {
                       final picker = new ImagePicker();
                       final PickedFile? pickedFile = await picker.getImage(
                         source: ImageSource.camera ,
                         imageQuality: 100
                         );

                         if (pickedFile ==null){
                           print('no selecciono nada');
                           return;
                         }
                         print('Tenemos una imagen ${pickedFile.path}');
                         productsServices.updateSelectedProductImage( pickedFile.path );

                     },
                     icon: const Icon( Icons.camera_alt_outlined, color: Colors.white,)
                   )
                   ),                     
               ],),
               _ProductForm(),
               const SizedBox(height: 100,),

           ],
         ),
         ),
         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
         floatingActionButton: FloatingActionButton(
           child:   productsServices.isSaving 
                ? CircularProgressIndicator( color: Colors.white)
                : const Icon( Icons.save_outlined),
           onPressed: productsServices.isSaving 
            ? null
            :  () async {
              if (! productForm.isValidForm() ) return ;

              final String? imageUrl = await productsServices.uploadImage();

              if (imageUrl != null ) productForm.product.picture= imageUrl;

              await productsServices.saveOrCreateProduct(productForm.product);
                

           },
           ) ,
    );
  }
}

class _ProductForm extends StatelessWidget {

  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final productForm = Provider.of<ProductFormProvider>(context);
      final product = productForm.product;

      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              
              const SizedBox(height: 10,),

              TextFormField(
                initialValue: product.name,
                onChanged: ( value ) => product.name=value  ,
                validator: ( value ) {
                  if (value==null || value.length<1){
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'),
              ),

              const SizedBox(height: 30,),


              TextFormField(
                initialValue: '${product.price}',
                //initialValue: product.price.toString(),
                //solo
                inputFormatters: [
                  // solo deja poner números
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ( value ) { 
                  if ( double.tryParse(value) == null )
                    product.price = 0;
                  else                     
                    product.price= double.parse(value);
                    },

                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:',
                  
                  ),
              ),
               const SizedBox(height: 30,),

              SwitchListTile.adaptive(                
                title: const Text('Disponible'),
                value: product.available, 
                activeColor: Colors.indigo,
              onChanged:  productForm.updateAvailability,
                
/*   hacen exactamente lo mismo
                onChanged: (value){
                       productForm.updateAvailability(value);
                }
                */
                ),

               const SizedBox(height: 30,),


            ],),
          ),

      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      boxShadow: [ BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset( 0,5 ),
        blurRadius: 5
      )]
    );
  }
}