import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/const/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:lost_and_found/ui/bottom_nav_controller.dart';
import '../widgets/customButton.dart';
import '../widgets/myTextField.dart';
import 'bottom_nav_pages/lost_item.dart';

class AddLostItems extends StatefulWidget {
  const AddLostItems({Key? key}) : super(key: key);

  @override
  State<AddLostItems> createState() => _AddLostItemsState();
}

class _AddLostItemsState extends State<AddLostItems> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  String downloadUrl = "";

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {

    if (downloadUrl.isEmpty){
      Fluttertoast.showToast(msg: "Please select item image");
      return;
    }
    if (_titleController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Item tittle");
      return;
    }
    if (_dobController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Date");
      return;
    }
    if (_detailsController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Details");
      return;
    }
    if (_locationController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Location");
      return;
    }


    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("lost-items-data");
    return _collectionRef.doc()
        .set({
      "email" : currentUser?.email,
      "image" : downloadUrl,
      "title" : _titleController.text.toUpperCase(),
      "dob": _dobController.text,
      "details": _detailsController.text,
      "location" : _locationController.text,
    })
        .then((value) =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => BottomNavController())))
        .catchError((error) => print("something is wrong. $error"));
  }

  // this section is for image upload in the firebase
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _imgFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        print('No image selected.');
        return;
      }

      setState(() {
        _photo = File(pickedFile.path);
        uploadFile();
      });
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    DateTime now = DateTime.now();

    final fileName = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    final destination = 'files/$fileName';

    try {
      // Fluttertoast.showToast(msg: "I am here");
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);

      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // this section is added later for final selection

                Text(
                  "Submit Lost Item Information.",
                  style:
                  TextStyle(fontSize: 19.sp, color: AppColors.deep_orange),
                ),
                Text(
                  "Please Enter The Correct Information inorder to find the product",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: _photo != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _photo!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 150,
                        height: 150,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 15.h,
                ),

                // this is single section

                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.title_outlined,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "example",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'TITLE',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.deep_orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Date Lost",
                          suffixIcon: IconButton(
                            onPressed: () => _selectDateFromPicker(context),
                            icon: Icon(Icons.calendar_today_outlined),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'DATE LOST',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.deep_orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.details_outlined,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _detailsController,
                        decoration: InputDecoration(
                          hintText: "Color of the product..",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'DETAILS',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.deep_orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.location_city_outlined,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: "Color of the product..",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'LOCATION',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.deep_orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),

                // elevated button
                customButton("Submit", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
