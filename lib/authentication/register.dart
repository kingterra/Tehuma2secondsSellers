import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodpanda_sellers_app/mainScreens/home_screen.dart';
import 'package:foodpanda_sellers_app/widgets/custom_text_field.dart';
import 'package:foodpanda_sellers_app/widgets/error_diolog.dart';
import 'package:foodpanda_sellers_app/widgets/loaading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodpanda_sellers_app/global/global.dart';

import '../persistent/persistent.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _RestaurantTypeListController = TextEditingController(text: 'Restaurant Type');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress ="";



  Future<void> _getImage() async
  {
   imageXFile= await _picker.pickImage(source: ImageSource.gallery);
   setState(() {
     imageXFile;
   });
  }


  getCurrentLocation() async
  {
    LocationPermission permission = await Geolocator.checkPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }




    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );


    Placemark pMark = placeMarks![0];

    completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;


  }


  Future<void> formValidation() async
  {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDiolog(
              message: "please select and image",
            );
          }
      );
    }


    else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty && nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          //we will start uploading the image
          showDialog(
            context: context,
            builder: (c){
              return LoadingDiolog(
                message: "Registering Account",
              );
            }
          );
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("sellers").child(fileName);
          fStorage.UploadTask uploadTask=reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            //SAVE INFO TO FIRESTORE

            authenticateSellerAndSignUp();



          });
        }
        else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDiolog(
                  message: "please write the complete required info for registretion",
                );
              }
          );
        }
      }
      else {
        //if the image dont match to each other

        showDialog(
            context: context,
            builder: (c) {
              return ErrorDiolog(
                message: "password do not match.",
              );
            }
        );
      }
    }
  }


  void authenticateSellerAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDiolog(
              message: error.message.toString(),
            );
          }
      );

    });

    if(currentUser !=null){ //if cuurent user has a value do the following
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context); //make the dialog or progress bar to desappear
        //send user to homepage
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);

      });
    }

  }


  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvaterUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "ResType": _RestaurantTypeListController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("ResType",  _RestaurantTypeListController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);






  }








  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.brown.shade800,
     body: SafeArea(
       minimum: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
       child: SingleChildScrollView(
         child: Column(
           mainAxisSize: MainAxisSize.max,
           children: [
             SizedBox(height: MediaQuery.of(context).size.height/20),
             InkWell(
              onTap: ()
              {
                _getImage();
              },
               child: CircleAvatar(
                 radius: MediaQuery.of(context).size.width * 0.20,
                 backgroundColor: Colors.white,
                 backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                 child: imageXFile ==null ?
                 Icon(
                   Icons.add_photo_alternate,
                   size: MediaQuery.of(context).size.width * 0.20,
                   color: Colors.grey,
                 ) :null

               ),
             ),
             const SizedBox(height: 10,),
             Form(
               key: _formkey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CustomTextField(
                     data: Icons.label,
                     controller: _RestaurantTypeListController,
                     enabled: false,
                     isObsecre: false,

                     fct:() {
                       _RestaurantTypeListDialog(size: size);

                     },

                   ),
                   CustomTextField(
                     data: Icons.person,
                     controller: nameController,
                     hintText: "Restaurant Name",
                     isObsecre: false,
                     fct:() {


                     },

                   ),
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
                     fct:() {},
                   ),
                   CustomTextField(
                     data: Icons.lock,
                     controller: confirmPasswordController,
                     hintText: "Confirm Password",
                     isObsecre: true,
                   ),
                   CustomTextField(
                     data: Icons.phone,
                     controller: phoneController,
                     hintText: "Phone Number",
                     isObsecre: false,
                     fct:() {},
                   ),
                   CustomTextField(
                     data: Icons.my_location,
                     controller: locationController,
                     hintText: "Restaurant Adress",
                     isObsecre: false,
                     enabled: true,
                     fct:() {

                     },

                   ),
                   const SizedBox(height: 30),
                   Container(
                     height: 40,
                     alignment: Alignment.center,
                     child: ElevatedButton.icon(
                       label: const Text(
                         "Get Current Location",
                         style: TextStyle(color: Colors.black, fontSize: 17),
                       ),
                       icon: const Icon(
                         Icons.location_on,
                         color: Colors.cyan,
                       ),
                       onPressed: ()
                       {
                         getCurrentLocation();
                       },
                       style: ElevatedButton.styleFrom(
                         primary: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                       ),
                     ),
                   ),

                 ],
               ),


             ),
             const SizedBox(height: 30),
             ElevatedButton(
               child: const Text(
                 "Sing Up",
                 style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,),

               ),
               style: ElevatedButton.styleFrom(
                 primary: Colors.white,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 10),
               ),
               onPressed: ()
               {
                 formValidation();
               },
             ),
             const SizedBox(height: 30),
           ],
         ),
       ),
     ),
    );
  }
  _RestaurantTypeListDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Restaturant type",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.RestaurantTypeList.length,
                  itemBuilder: (ctxx, index)
                  {return InkWell(
                    onTap: ()
                    {
                      setState(() {

                        _RestaurantTypeListController.text = Persistent.RestaurantTypeList[index];

                      });
                      Navigator.pop(context);

                    },

                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),

                          child: Text(
                            Persistent.RestaurantTypeList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),


                        ),
                      ],
                    ),
                  );

                  }

              ),
            ),

            actions: [
              TextButton(
                onPressed: (){


                  Navigator.canPop(context) ? Navigator.pop(context): null;

                }, child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white,
                    fontSize: 16),

              ),
              ),
            ],
          );
        }
    );
  }
}
