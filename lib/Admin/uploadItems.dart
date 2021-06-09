import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptiontexteditingcontroller = TextEditingController();
  TextEditingController _pricetexteditingcontroller = TextEditingController();
  TextEditingController _titletexteditingcontroller = TextEditingController();
  TextEditingController _shortinfotexteditingcontroller = TextEditingController();
 String productId = DateTime.now().millisecondsSinceEpoch.toString();
 bool uploading = false;


  @override
  Widget build(BuildContext context) {
    return file==null ? displayAdminHomeScreen() : displayAdminFormUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.border_color,color: Colors.white,),
          onPressed: (){
            Route route = MaterialPageRoute(builder:(c)=> AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          TextButton(
            child: Text("Logout",style: TextStyle( color: Colors.pink, fontSize: 16,
              fontWeight: FontWeight.bold,

            ),),
           onPressed: (){Route route = MaterialPageRoute(builder:(c)=> SplashScreen());
           Navigator.pushReplacement(context, route);},

          ),
        ],
      ),
     body: getAdminHomeScreenBody(),
    );
  }
  getAdminHomeScreenBody(){
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(Icons.shop_two,size: 200, color: Colors.white,),
            Padding(padding: EdgeInsets.only(top: 20),),
            FlatButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0),

            ) ,
              child: Text("Add New Product", style: TextStyle(color: Colors.white,fontSize: 20),
              ),
              color: Colors.green,
              onPressed: ()=> takePicture(context),

            ),
          ],
        ),
      ),
    );
  }
  takePicture(mcontext){


    return showDialog(context: mcontext, builder: (con){
       return SimpleDialog(
         title: Text("Item image", style:
         TextStyle(color: Colors.green,
             fontWeight: FontWeight.bold),),
         children: [
           SimpleDialogOption(
             child: Text(" Capture Image",style:
            TextStyle(color: Colors.green,),
             ),
             onPressed: CapturephotoWithCamera,
           ),
                 SimpleDialogOption(
                   child: Text("Select From Gallery",style:
                  TextStyle(color: Colors.green,),
                  ),
                   onPressed: Capturephotofromgallery,


      ),
           SimpleDialogOption(
             child: Text("Cancel",style:
             TextStyle(color: Colors.green,),
             ),
             onPressed:(){
              Navigator.pop(context);
             },


           ),
         ],
       );


    });
  }
  CapturephotoWithCamera() async{
   File imagFile= await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 970, maxHeight:680 );
   setState(() {
     file=imagFile;
   });
  }
  Capturephotofromgallery() async{

    File imagFile = await ImagePicker.pickImage(source: ImageSource.gallery,);
    setState(() {
      file=imagFile;
    });


  }
  displayAdminFormUploadScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
        colors: [Colors.pink, Colors.lightGreenAccent],
        begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
         stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
         ),
         ),
         ),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: clearFormInfo,),
             title: Text("New Product",style:
             TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
             actions: [
                 TextButton(onPressed: uploading?null : ()=> uploadSaveItemInfo()
                   , child: Text("ADD",
                     style: TextStyle(color:
                     Colors.pink,fontSize: 16,fontWeight: FontWeight.bold),))
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image:
                  DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover),


                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _shortinfotexteditingcontroller,
                decoration: InputDecoration(
                  hintText: "Short-info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _titletexteditingcontroller,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _descriptiontexteditingcontroller,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _pricetexteditingcontroller,
                decoration: InputDecoration(
                  hintText: "Prices",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),

        ],
      ),
    );

  }
  clearFormInfo()
  {
   setState(() {
     file = null;
     _pricetexteditingcontroller.clear();
     _descriptiontexteditingcontroller.clear();
     _shortinfotexteditingcontroller.clear();
     _titletexteditingcontroller.clear();
   });
  }
  uploadSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });
   String imageDownloadUrl = await uploadImageItem(file);
   saveItemInfo(imageDownloadUrl);


  }
  Future<String> uploadImageItem(mfileImag) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().
    child("items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").
    putFile(mfileImag);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl)

  {
    final itemRef = Firestore.instance.collection("items");
    itemRef.document(productId).setData({
      "shortInfo":_shortinfotexteditingcontroller.text.trim(),
      "longDescription":_descriptiontexteditingcontroller.text.trim(),
      "title":_titletexteditingcontroller.text.trim(),
      "price":int.parse(_pricetexteditingcontroller.text),
      "publishedDate":DateTime.now(),
      "status":"available",
      "thumbnailUrl": downloadUrl,


    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontexteditingcontroller.clear();
      _titletexteditingcontroller.clear();
      _pricetexteditingcontroller.clear();
      _shortinfotexteditingcontroller.clear();


    });
  }
}