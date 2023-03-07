import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superfood_riders_app/authentication/auth_screen.dart';
import 'package:superfood_riders_app/mainScreens/home_screen.dart';

import '../global/global.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  formValidation(){ //giriş yapılırken kontrol edilir. yanlış girişte hata mesajı verir. yazılmadan giriş yapılırsa hata verir.
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
      {
        //giriş
        loginNow();
      }
    else
      {
        showDialog(
            context: context,
            builder: (c)
        {
          return ErrorDialog(message: "Please write email/password.",);
        }
        );
      }
  }

  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingDialog(message: "Cheking Credentials",);
        }
    );

    User? currenUser;
    await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
    ).then((auth)
    {
      currenUser = auth.user!;
    }).catchError((error)
    {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(message: error.message.toString(),);
          }
      );
    }
    );
    if(currenUser != null)
      {
        readDataAndSetDataLocally(currenUser!);
      }
  }


  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).
    get().then((snapshot) async {
      if(snapshot.exists)
      {
        if(snapshot.data()!["status"] == "approved")
          {
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["riderEmail"]); //isimleri firebase google da yazılanlardan alındı.
            await sharedPreferences!.setString("name", snapshot.data()!["riderName"]); //isimleri firebase google da yazılanlardan alındı.
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["riderAvatarUrl"]); //isimleri firebase google da yazılanlardan alındı.

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          }
        else
          {
            firebaseAuth.signOut();
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Admin has blocked you. \n\nEmail here: admin@superfoodapp.com");
          }
      }
      else
      {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(message: "no record exists.",);
            }
        );
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: EdgeInsets.all(15),
            child: Image.asset("images/signup.png",
            height: 270,
            ),

            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: (){
              formValidation();
            },
          ),
        ],
      ),
    );
  }
}
