import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/ui/bottom_nav_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../const/app_colors.dart';
import '../widgets/customButton.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  // Added for testing
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  String downloadUrl="";

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  sendUserDataToDB() async {

    if (_emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Your Email Addess");
      return;
    }
    if (_nameController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Your Name");
      return;
    }
    if (_phoneController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Your Phone Number");
      return;
    }
    if (_genderController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Select your gender");
      return;
    }
    if (downloadUrl.isEmpty){
      Fluttertoast.showToast(msg: "Please Select your profile img");
      return;
    }
    // Fluttertoast.showToast(msg: );
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("user-form-data");  // the location where the file will be store
    return _collectionRef.doc(currentUser?.email).set({
      "email": _emailController.text,
      "name": _nameController.text,
      "phone": _phoneController.text,
      "gender": _genderController.text,
      "photo" : downloadUrl,
    }).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavController())   // navigate to the next page
    ).catchError(
            (error) => Fluttertoast.showToast(msg: "Something is wrong")
    )

        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something is wrong")));
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

  Future uploadFile() async { //this will upload the profile picture of the user
    if (_photo == null) return;

    DateTime now = DateTime.now();

    final fileName = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    final destination = 'files/$fileName'; // replace the file name with current time

    try {
      // Fluttertoast.showToast(msg: "I am here");
      final ref = firebase_storage.FirebaseStorage.instance // store the image into firestore
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);

      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // this is added for testing
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style:
                  TextStyle(fontSize: 22.sp, color: AppColors.deep_orange),
                ),
                Text(
                  "We will not share your information with anyone.",
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
                          Icons.email_outlined,
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "example@gmail.com",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'EMAIL',
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
                          Icons.drive_file_rename_outline,
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Example",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'NAME',
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

                // single section End here

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
                          Icons.phone_android_outlined,
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
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: "Enter With country code Ex: +880***",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF414041),
                          ),
                          labelText: 'PHONE',
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
                          Icons.person_2_outlined,
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
                        controller: _genderController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "choose your gender",
                          prefixIcon: DropdownButton<String>(
                            items: gender.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                                onTap: () {
                                  setState(() {
                                    _genderController.text = value;
                                  });
                                },
                              );
                            }).toList(),
                            onChanged: (_) {},
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
                customButton(
                  "Continue",
                      () {
                    sendUserDataToDB();
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
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
