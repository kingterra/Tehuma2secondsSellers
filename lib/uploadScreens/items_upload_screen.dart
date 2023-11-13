import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_sellers_app/global/global.dart';
import 'package:foodpanda_sellers_app/mainScreens/home_screen.dart';
import 'package:foodpanda_sellers_app/model/menus.dart';
import 'package:foodpanda_sellers_app/widgets/error_diolog.dart';
import 'package:foodpanda_sellers_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;


class ItemsUploadScreen extends StatefulWidget {

  final Menus? model;
  //we most receive the parameter model by requiered
  //becourse item depend on a menu
  ItemsUploadScreen({required this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInforController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber

              ],
              begin:  FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Add New Items",
          style: TextStyle(
              fontSize: 30,
              fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber

            ],
            begin:  FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.white, size: 200.0,),
              ElevatedButton(
                child: const Text(
                  "Add New Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)

                    ),
                  ),
                ),
                onPressed: (){
                  takeImage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return SimpleDialog(
          title: const Text("Menu Image ", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Capture With Camera",
                style: TextStyle(color: Colors.grey,),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: const Text(
                "Select From Gallery",
                style: TextStyle(color: Colors.grey,),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red,),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });

  }

  ItemsUploadFormScreen()
  {
    return Scaffold(

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber

              ],
              begin:  FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Uploading New Item",
          style: TextStyle(
              fontSize: 20,
              fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenusUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Varela",
                letterSpacing: 3,
              ),
            ),
            onPressed: ()
            {
              //if the uploading is true do nothing eles validate

              uploading ? null : validateUploadForm();

            },
          ),
        ],
      ),

      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text (""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

          ),

          const Divider(
            color: Colors.amber,
            thickness: 1,

          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInforController,
                decoration: const InputDecoration(
                  hintText: "Info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,

          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Menu title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,

          ),

          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,

          ),

          ListTile(
            leading: const Icon(Icons.money, color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextField(
                //el tipo de dato de precio sera numerico
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,

          ),
        ],
      ),

    );
  }

  clearMenusUploadForm()
  {
    setState(() {
      shortInforController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async
  {


    if(imageXFile !=null)
    {
      if(shortInforController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //start uploading the image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to firestore
        saveInfo(downloadUrl);


      }else
      {

        showDialog(
            context: context,
            builder: (c) {
              return ErrorDiolog(
                message: "please write title and info for menu",
              );
            }
        );

      }

    }else
    {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDiolog(
              message: "please pick an image for menu.",
            );
          }
      );
    }
  }


  saveInfo( String downloadUrl)
  {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(widget.model!.menuID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID" : uniqueIdName,
      "menuID" : widget.model!.menuID,
      "sellersUID" : sharedPreferences!.getString("uid"),
      "sellerName" : sharedPreferences!.getString("name"),
      "shortInfo" : shortInforController.text,
      "longDescription" : descriptionController.text,
      "price" : int.parse(priceController.text),
      "title" : titleController.text.toString(),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnnailUrl" : downloadUrl,

    }).then((value)
    {
        final itemRef = FirebaseFirestore.instance
            .collection("items");

        itemRef.doc(uniqueIdName).set({
          "itemID" : uniqueIdName,
          "menuID" : widget.model!.menuID,
          "sellersUID" : sharedPreferences!.getString("uid"),
          "sellerName" : sharedPreferences!.getString("name"),
          "shortInfo" : shortInforController.text,
          "longDescription" : descriptionController.text,
          "price" : int.parse(priceController.text),
          "title" : titleController.text.toString(),
          "publishedDate" : DateTime.now(),
          "status" : "available",
          "thumbnnailUrl" : downloadUrl,

        });


    }).then((value){
      clearMenusUploadForm();
      setState(() {
        uniqueIdName =DateTime.now().millisecondsSinceEpoch.toString();
        uploading =false;
      });

    });


  }

  //pasamos la imegen que selecciono el usuario comp parametro
  uploadImage(mImageFile) async
  {
    // creamos un fichero menus en firebase storage
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;

  }







  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : ItemsUploadFormScreen();
  }
}



