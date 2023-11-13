import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_sellers_app/authentication/auth_screen.dart';
import 'package:foodpanda_sellers_app/authentication/register.dart';
import 'package:foodpanda_sellers_app/global/global.dart';
import 'package:foodpanda_sellers_app/mainScreens/InitialScreen.dart';
import 'package:foodpanda_sellers_app/mainScreens/home_screen.dart';
import 'package:foodpanda_sellers_app/widgets/error_diolog.dart';
import 'package:foodpanda_sellers_app/widgets/loaading_dialog.dart';

import '../widgets/custom_text_field.dart';
import 'forget_pass.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //Login
      LogiNow();

    }
    else
      {
        showDialog(
          context: context,
          builder: (c){
            return ErrorDiolog(message: "Please write email/password.",);
          }
        );
      }
  }

  LogiNow() async
   {
    showDialog(
        context: context,
        builder: (c){
          return LoadingDiolog(
            message: "Checking Credentials",);
        }
    );
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),

    ).then((auth) {
      currentUser= auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorDiolog(message: error.message.toString(),
            );
          }
      );

    });
    if(currentUser !=null){

      readDataAndSetDataLocally(currentUser!);

    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("sellers") //from this sellers collection
        .doc(currentUser.uid) //this spacific user
        .get().then((snapshot) async  { //get data locally
          if(snapshot.exists){
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
            await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvaterUrl"]);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => InitialScreen()));

          }else{
            firebaseAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
            showDialog(
                context: context,
                builder: (c){
                  return ErrorDiolog(message: "no record found.",
                  );
                }
            );
          }





    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade800,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //SizedBox(height: MediaQuery.of(context).size.height/13),
            Container(
              alignment: Alignment.bottomCenter,

                child: Image.asset(
                  "images/LoginImage.gif",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  //height: 270,
                ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/10),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
            ),
            ElevatedButton(
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,),

              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 78, vertical: 10),

              ),
              onPressed: ()
              {
                formValidation();
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,),

              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),

              ),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: const Text(
                'Forget password?',
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,),

              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),

              ),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
