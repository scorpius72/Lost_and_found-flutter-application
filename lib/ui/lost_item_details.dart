import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const/app_colors.dart';
import 'bottom_nav_controller.dart';

class LostItemDetails extends StatefulWidget {
  var _product;
  LostItemDetails(this._product);

  @override
  State<LostItemDetails> createState() => _LostItemDetailsState();
}

class _LostItemDetailsState extends State<LostItemDetails> {

  Future addToFound() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-found-items");
    return _collectionRef
        .doc(widget._product['email'])
        .collection("items")
        .doc(widget._product['email']+widget._product["title"])
        .set({
      "email" : currentUser?.email,
      "phone": queryResult[0]['phone'],
      "image" : widget._product["image"],
      "title" : widget._product["title"],
      "dob": widget._product["dob"],
      "details": widget._product["details"],
      "location" : widget._product["location"],

    }).then((value) => Fluttertoast.showToast(msg: "Product added to the found list successfully"));

  }

  var currentUser = FirebaseAuth.instance.currentUser;

  List<DocumentSnapshot> queryResult=[];

// Create a function to retrieve the Firestore query result
  void getQueryResult() async {
    // Retrieve the query result
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("user-form-data")
        .where("email", isEqualTo: currentUser?.email)
        .get();

    // Save the query result into the variable
    queryResult = snapshot.docs;
    // Fluttertoast.showToast(msg: queryResult[0]['phone']);
  }

  var UserEmail ; // this is the current user email address
  var is_delete = false;

  @override
  void initState() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    UserEmail = currentUser?.email;
    if (UserEmail==widget._product['email']) is_delete = true;
    getQueryResult();
    // TODO: implement initState
    super.initState();
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
              ),
            ),
          ),
        ),
        title: Text(
          'Item Details',
          style: TextStyle(
            color: AppColors.deep_orange,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Visibility(
            visible: is_delete,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('lost-items-data') // Replace with your collection name
                      .where('email', isEqualTo: UserEmail)
                      .where('title', isEqualTo: widget._product['title']) // Replace with your field name and desired value
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
                      documentSnapshot.reference.delete().then((value) {
                        // Document successfully deleted
                        Fluttertoast.showToast(msg: 'item deleted successfully');
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(builder: (_) => BottomNavController()),
                        );
                      }).catchError((error) {
                        // Error occurred while deleting document
                        print('Failed to delete document: $error');
                        Fluttertoast.showToast(msg: 'Failed to delete document: $error');
                      });
                    });
                  })
                      .catchError((error) {
                    // Error occurred while querying documents
                    print('Failed to retrieve documents: $error');
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.deep_orange,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
            color: Color(0xFFF3F0F0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    AspectRatio(
                      aspectRatio: 1.3,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage( widget._product['image']),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.title, color: Colors.black),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      widget._product['title'].toString().toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.calendar_month_outlined, color: Colors.black),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      widget._product['dob'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.details, color: Colors.black),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      widget._product['details'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.location_city_outlined, color: Colors.black),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      "${widget._product['location'].toString()}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    Divider(),
                    SizedBox(
                      width: 1.sw,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () => addToFound(),
                        child: Text(
                          "Found Item",
                          style: TextStyle(color: Colors.white, fontSize: 18.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.deep_orange,
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
