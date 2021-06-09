
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin:  const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text('e-Shop',
            style: TextStyle(
                fontSize: 55,
                fontFamily: "Signatra"
            ),),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart,color: Colors.pink,),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder:(c)=> CartPage());
                    Navigator.pushReplacement(context, route);
                  }


                  ,),
            Positioned(child: Stack(
              children: [
                Icon(Icons.brightness_1,size: 20, color: Colors.green,),
                Positioned(top:4 ,bottom: 4,left: 3,
                  child: Consumer<CartItemCounter>(
                    builder: (context,counter,_){
                    return Text(
                      (EcommerceApp.sharedPreferences.
                      getStringList(EcommerceApp.userCartList).length-1).toString(),
                      style: TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500,
                      ),
                    );
                    }
                  ),)
              ],
            ),) ,
              ],
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned :true ,delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(stream: Firestore.instance.collection("items").
            orderBy("publishedDate",descending: true).snapshots(),
            builder: (context ,dataSnapshot){
              return !dataSnapshot.hasData ? SliverToBoxAdapter(child:
              Center(child: circularProgress(),),) :
                  SliverStaggeredGrid.countBuilder
                    (
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context,index)
                    {
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.documents.length,
                  );
            },)
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder:(c)=> ProductPage(itemModel: model,));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(padding: EdgeInsets.all(6.0),
    child: Container(
      height: 190,
      width: width,
      child: Row(
        children: [
          Image.network(model.thumbnailUrl,width: 140,height: 140,),
          SizedBox(width: 4,),
          Expanded(child:
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(model.title,
                      style: TextStyle(color: Colors.black,fontSize: 14),

                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(model.shortInfo,
                      style: TextStyle(color: Colors.black54,fontSize: 12.0),

                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.pink,

                    ),
                    alignment: Alignment.topLeft,
                    width: 40,
                     height: 43,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("50%",style: TextStyle(color: Colors.white,fontSize: 15,
                          fontWeight: FontWeight.normal),),
                          Text("OFF",style: TextStyle(color: Colors.white,fontSize: 12,
                              fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 0.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Text("original price:",
                              style: TextStyle(color: Colors.grey,fontSize: 14,
                                  decoration: TextDecoration.lineThrough),),
                            Text((model.price + model.price).toString(),
                              style: TextStyle(color: Colors.grey,fontSize: 15,decoration: TextDecoration.lineThrough),
                            ),
                            Text("Dh",
                              style: TextStyle(color: Colors.grey,fontSize: 14,
                                  ),),


                          ],
                        ),
                      ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0),
                        child: Expanded(
                          child: Row(
                            children: [
                              Text("new price:",
                                style: TextStyle(color: Colors.grey,fontSize: 14),),
                              Text((model.price).toString(),
                                style: TextStyle(color: Colors.grey,fontSize: 15),),
                              Text("Dh",
                                style: TextStyle(color: Colors.grey,fontSize: 14,
                                    ),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Flexible(
                  child: Container(),

              ),
              Align(
                alignment: Alignment.centerRight,
                child: removeCartFunction ==null
                    ? IconButton(icon: Icon(Icons.add_shopping_cart,color: Colors.pinkAccent,),
                    onPressed: (){
                      checkItemInCart(model.shortInfo, context);
                    })
                    :  IconButton(icon: Icon(Icons.remove_shopping_cart,color: Colors.pinkAccent,),
                    onPressed: (){
                      removeCartFunction();
                      Route route = MaterialPageRoute(builder:(c)=> StoreHome());
                      Navigator.pushReplacement(context, route);
                    })

              ),
              Divider(height: 5,
              color: Colors.pink,)

            ],
          ),
          ),



        ],
      ),
    ),
    ),

  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height:150 ,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5),blurRadius: 10.0,color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(imgPath,height:150 ,
        width: width * .34,fit: BoxFit.fill,),

    ),
  );
}



void checkItemInCart(String shortInfoAsId, BuildContext context)
{

  EcommerceApp.sharedPreferences.getStringList(
      EcommerceApp.userCartList).contains(shortInfoAsId) ?
  Fluttertoast.showToast(msg: "Item Already Exist in Cart."):
      addItemToCart(shortInfoAsId,context);
  
}
addItemToCart(String shortInfoAsId , BuildContext context)
{
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(
      EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsId);
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
  document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).
  updateData({
    EcommerceApp.userCartList : tempCartList
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to Cart , Successfully.");
    EcommerceApp.sharedPreferences.
    setStringList(EcommerceApp.userCartList,tempCartList);
    Provider.of<CartItemCounter>(context , listen: false).displayResult();
  });




}