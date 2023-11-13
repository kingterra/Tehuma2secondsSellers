import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_sellers_app/authentication/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:foodpanda_sellers_app/authentication/register.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController forgetPassTextController = TextEditingController(text: '');

  void _forgetPasFCT() async{
    try{
      await _auth.sendPasswordResetEmail(
        email:forgetPassTextController.text,
      );
      Navigator.pop(context);
    }catch(error){
      Fluttertoast.showToast(msg: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.black,


      body: Stack(
        children: [


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  'Forget password',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email address',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: forgetPassTextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  onPressed: _forgetPasFCT,
                  color: Colors.pink.shade700,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Reset now',
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

            ],
          ),
        );

  }
}
