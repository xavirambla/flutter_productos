import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({ Key? key, required this.product }) : super(key: key);

  final Product product ;
  
    @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30,bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child:Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: product.picture ),
            _ProductDetails(title: product.name, subTitle: product.id! ),
            Positioned(
              top:0,
              right:0,
              child: _PriceTag( price: product.price, )),
              
            if(!product.available)
              Positioned(
                top:0,
                left:0,
                child: _NotAvailable()),              
          ],
          )
        
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0,7),
        ),
        ]

      );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const  FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('No disponible',
                style: TextStyle( color: Colors.white,fontSize: 20),
          )
          ,),
        ),
        width: 100,
        height: 70,
        decoration:   BoxDecoration(color: Colors.yellow[800], 
        borderRadius:const  BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price ;
  
  const _PriceTag({
    Key? key, required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(  //como queremos que se adapte el widget interno
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("\$$price", style: const TextStyle(color:Colors.white, fontSize: 20),)),
      ),
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
    );
  }
}



class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;
  
  const _ProductDetails({
    Key? key, 
    required this.title, 
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        width: double.infinity,
        height: 70,
      //  color:Colors.indigo,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
              title ,
              style: const TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
          ),
            Text(
              subTitle ,
              style: const TextStyle(fontSize: 15,color: Colors.white, ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
          ),          
          ]

        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(25) , topRight: Radius.circular(25) )

  );
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage({
    Key? key, this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        //color:Colors.red,
        child : 
               (url == null)
              ? const Image(
                image:AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
                  )
              : FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage( url! ),
          fit: BoxFit.cover,
          )
      ),
    );
  }
}