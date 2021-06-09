import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final TextEditingController _adminIdTextEditingController=TextEditingController();
  final TextEditingController _passTextEditingController=TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    double _screenWidth=MediaQuery.of(context).size.width , _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child:  Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin:  const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/admin.png",height: 240.0 ,width: 240.0 ,),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child: Text("Login To Your Account", style: TextStyle(color: Colors.white),

              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    data: Icons.person,
                    controller: _adminIdTextEditingController,
                    hintText: "AdminID",
                    isObsecure: false,

                  ),
                  CustomTextField(
                    data: Icons.security,
                    controller: _passTextEditingController,
                    hintText: "password",
                    isObsecure: true,

                  ),
                  SizedBox(height: 25,),

                  ElevatedButton(
                    onPressed: (){ _adminIdTextEditingController.text.isNotEmpty &&
                        _passTextEditingController.text.isNotEmpty
                        ? loginAdmin()
                        : showDialog(context: context,
                        builder: (c){
                          return ErrorAlertDialog(message: "Please write your ID and Password",);
                        });},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink),
                    ),
                    child: Text("LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                  ),
                  SizedBox(height: 50,),
                  Container(
                    height: 4,
                    width: _screenWidth*0.8,
                    color: Colors.pink,
                  ),
                  SizedBox(height: 20,),

                  FlatButton.icon(onPressed: ()=> Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AuthenticScreen(),  ),
                  ),
                    icon: Icon(Icons.nature_people),color: Colors.pink,
                    label: Text("I'M Not  Admin ",style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),

                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ],
         ),
      ),
    );
  }
  loginAdmin()
  {
 Firestore.instance.collection("admins").getDocuments().then((snapshot){
   snapshot.documents.forEach((results) {
     if(results.data["id"] != _adminIdTextEditingController.text.trim()){
       Scaffold.of(context).showSnackBar(SnackBar(
         content: Text('your ID is not correct'),));

     }
     else if(results.data["password"] != _passTextEditingController.text.trim()){

       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
               content: Text("your Password id not correct")));

     }
     else{
       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
               content: Text("Welcome Dear Admin " + results.data['name'])));
     }
     setState(() {
       _adminIdTextEditingController.text = "";
       _passTextEditingController.text = "";
     });
     Route route = MaterialPageRoute(builder:(c)=> UploadPage());
     Navigator.pushReplacement(context, route);

   });
 });
  }
}
