import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/placeOrderPayment.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Models//address.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{

  final double totalAmount;
  const Address({Key key , this.totalAmount}): super(key:key);

  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text("Select Your Address",
                style: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context , address,c){
              return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore.
                    collection(EcommerceApp.collectionUser)
                        .document(EcommerceApp.
                    sharedPreferences.
                    getString(EcommerceApp.userUID)).
                    collection(EcommerceApp.subCollectionAddress).snapshots(),
                    builder: (context,snapshot){
                      return !snapshot.hasData ? Center(
                        child:circularProgress() ,):snapshot.data.
                      documents.length ==0 ? noAddressCard()
                          : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                         shrinkWrap: true,
                         itemBuilder: (context,index){
                            return AddressCard(
                              currentIndex: address.count,
                              value: index,
                              AddressId: snapshot.data.documents[index].documentID,
                              totalAmount: widget.totalAmount,
                              model: AddressModel.fromJson(snapshot.
                              data.documents[index].data)
                            );
                         },
                      );
                    },
                  ),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              Route route = MaterialPageRoute(builder:(c)=> AddAddress());
              Navigator.pushReplacement(context, route);
            }, label: Text("Add New Address"),
          backgroundColor: Colors.pink,
        icon: Icon(Icons.add_location,),
        ),
      ),

    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location,color: Colors.white,),
            Text("No Shipment Address has been saved"),
            Text("Please Add Your Shipment Address"),

          ],
        ),
      ),

    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String AddressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  AddressCard({Key key , this.model,
    this.totalAmount,this.AddressId,this.currentIndex,this.value}) :super(key: key);


  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenwidth =MediaQuery.of(context).size.width;

    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context,listen: false).
        displayResult(widget.value);

      },
     child: Card(
       color: Colors.pinkAccent.withOpacity(0.4),
       child: Column(
         children: [
           Row(
             children: [
               Radio(value: widget.value,
                   groupValue: widget.currentIndex,
                 activeColor: Colors.pink,
                   onChanged: (val){
                   Provider.of<AddressChanger>(context,listen: false).displayResult(val);
                   },
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     padding: EdgeInsets.all(10),
                     width: screenwidth *0.8,
                      child: Table(
                          children: [
                         TableRow(
                        children: [
                          KeyText(msg: "NAME",),
                        Text(widget.model.name),

                        ],
                        ),
                            TableRow(
                              children: [
                                KeyText(msg: "Phone Number",),
                                Text(widget.model.phoneNumber),

                              ],
                            ),
                            TableRow(
                              children: [
                                KeyText(msg: "City",),
                                Text(widget.model.city),

                              ],
                            ),
                            TableRow(
                              children: [
                                KeyText(msg: "Your Addresse",),
                                Text(widget.model.state),

                              ],
                            ),
                        ],
                         ),

                   ),
                   ],
                  ),
             ],
           ),
           widget.value == Provider.of<AddressChanger>(context).count
               ? WideButton(
             message: "Proceed",
             onpressed: (){
               Route route = MaterialPageRoute(builder: (c)=> PaymentPage(
                   addressId: widget.AddressId,
                   totalAmount:widget.totalAmount,

               ),
               );
               Navigator.push(context, route);
             },
           ): Container(),
         ],
       ),
     ),
    );
  }
}





class KeyText extends StatelessWidget {
 final String msg;
 KeyText({Key key,this.msg}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(msg,style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.bold),
    );
  }
}
