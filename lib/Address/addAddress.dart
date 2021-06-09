import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formKey =GlobalKey<FormState>();
  final scaffoldKey =GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cnumberPhone = TextEditingController();
  final cCity = TextEditingController();
  final cAddress = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended
          (onPressed: (){
            if(formKey.currentState.validate()){
              final model =AddressModel(
                name: cName.text.trim(),
                phoneNumber: cnumberPhone.text.trim(),
                city: cCity.text.trim(),
                state: cAddress.text.trim(),
              ).toJson();
              EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
          document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).
              collection(EcommerceApp.subCollectionAddress).
              document(DateTime.now().millisecondsSinceEpoch.toString()).
          setData(model).then(
                      (value){
                        final snack = SnackBar(content:
                        Text("New Address added successfully."));
                        // ignore: deprecated_member_use
                        scaffoldKey.currentState.showSnackBar(snack);
                        FocusScope.of(context).requestFocus(FocusNode());
                        formKey.currentState.reset();

                      });
              Route route = MaterialPageRoute(builder:(c)=> StoreHome());
              Navigator.pushReplacement(context, route);
            }
        }, label: Text("Confirm"),
          backgroundColor: Colors.pink,icon:
          Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(padding:EdgeInsets.all(8),
                child: Text("Add New Address",
                  style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,
                  ),
                ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.grey,
                       borderRadius: BorderRadius.all(
                           Radius.circular(10.0)),
                     ),
                     padding: EdgeInsets.all(8),
                     margin: EdgeInsets.all(10),
                     child: MyTextField(
                       hint: "Enter your Name",
                       controller: cName,
                     ),
                   ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(10),
                      child: MyTextField(
                        hint: "Enter your NumberPhone",
                        controller: cnumberPhone,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(10),
                      child: MyTextField(
                        hint: "Enter your City",
                        controller: cCity,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(10),
                      child: MyTextField(
                        hint: "Enter your Address",
                        controller: cAddress,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
 final String hint;
 final TextEditingController controller;
 MyTextField({Key key , this.hint,this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (v)=>v.isEmpty ? "Field can Not be Empty" : null,

      ),
    );
  }
}
