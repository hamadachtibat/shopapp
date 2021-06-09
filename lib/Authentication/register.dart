import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController=TextEditingController();
  final TextEditingController _emailTextEditingController=TextEditingController();
  final TextEditingController _passTextEditingController=TextEditingController();
  final TextEditingController _cpassTextEditingController=TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imagFile ;
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width , _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child:Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            SizedBox(height: 10,),
            InkWell(
             onTap: _selectAndPickImg ,
             child: CircleAvatar(
              radius: _screenWidth * 0.15 ,
               backgroundColor: Colors.white,
               backgroundImage: _imagFile == null ? null : FileImage(_imagFile),
               child: _imagFile==null ? Icon(Icons.add_a_photo,size: _screenWidth * 0.15 ,color: Colors.grey,)
              : null ,
    ),
    ),
            SizedBox(height: 8,),
            Form(
              key: _formKey,
              child: Column(
               children: [
                 CustomTextField(
                   data: Icons.person,
                   controller: _nameTextEditingController,
                   hintText: "Name",
                   isObsecure: false,

                 ),
                 CustomTextField(
                   data: Icons.email,
                   controller: _emailTextEditingController,
                   hintText: "email",
                   isObsecure: false,

                 ),
                 CustomTextField(
                   data: Icons.security,
                   controller: _passTextEditingController,
                   hintText: "password",
                   isObsecure: true,

                 ),
                 CustomTextField(
                   data: Icons.person,
                   controller: _cpassTextEditingController,
                   hintText: "confirm your password",
                   isObsecure: true,

                 ),
               ],
              ),
            ),
          ElevatedButton(
               onPressed: (){ uploadAndSaveImg();},
               style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink),),
               child: Text("Sign Up",
               style: TextStyle(
                 color: Colors.white,
               ),),
           ),
            SizedBox(height: 30,),
            Container(
              height: 4,
              width: _screenWidth*0.8,
              color: Colors.pink,
            ),
            SizedBox(height: 15,),

          ],
        ) ,
      ),
    );
  }
  Future<void>_selectAndPickImg() async {
    _imagFile=await ImagePicker.pickImage(source:ImageSource.gallery);
  }
  Future <void> uploadAndSaveImg() async {
    if (_imagFile == null) {
      showDialog(context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "Please select an Image",);
          });
    }
    else {
      _passTextEditingController.text == _cpassTextEditingController.text ?
      _passTextEditingController.text.isNotEmpty
          && _cpassTextEditingController.text.isNotEmpty
          && _emailTextEditingController.text.isNotEmpty
          && _nameTextEditingController.text.isNotEmpty
          ? uploadToStorage()
          : displayError("please complete the registration")
          : displayError("the passwords not match");
    }
  }

  displayError(String msg){
    showDialog(context: context,
    builder: (c){
     return ErrorAlertDialog(message: msg,);
    });
  }
  uploadToStorage() async{
    showDialog(context: context,
    builder: (c){
      return LoadingAlertDialog(message: "Registration please wait...",);

    });
String ImagName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(ImagName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imagFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((imageUrl){
      userImageUrl = imageUrl ;
      _registreUser();
    });
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registreUser() async{
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passTextEditingController.text.trim(),

    ).then((auth){
      firebaseUser = auth.user ;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
      builder: (c){
        return ErrorAlertDialog(message: error.msg.toString(),);
      });

    });
 if(firebaseUser != null){
   saveUserInfoToFirstore(firebaseUser).then((value){
     Navigator.pop(context);
     Route route = MaterialPageRoute(builder:(c)=>StoreHome());
     Navigator.pushReplacement(context, route);
   });
 }
  }
   Future saveUserInfoToFirstore(FirebaseUser fUser) async{
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid" : fUser.uid,
      "email" : fUser.email,
      "name" : _nameTextEditingController.text.trim(),
      "url" : userImageUrl,
      EcommerceApp.userCartList : ["carbageValue"],

    });
   await  EcommerceApp.sharedPreferences.setString("uid" ,fUser.uid);
    await  EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail ,fUser.email);
    await  EcommerceApp.sharedPreferences.setString(EcommerceApp.userName ,_nameTextEditingController.text);
    await  EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl ,userImageUrl);
    await  EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList ,["carbageValue"]);


   }
}

