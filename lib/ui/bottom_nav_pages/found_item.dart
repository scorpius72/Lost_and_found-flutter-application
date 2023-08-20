import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../const/app_colors.dart';
import '../found_item_details.dart';
import '../login_screen.dart';
import '../lost_item_details.dart';
import '../search_screen.dart';

class Found extends StatefulWidget {
  const Found({Key? key}) : super(key: key);

  @override
  State<Found> createState() => _FoundState();
}

class _FoundState extends State<Found> {

  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchProducts() async {
    // Fluttertoast.showToast(msg: "Hello");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    QuerySnapshot qn =
    await _firestoreInstance.collection("users-found-items").doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "email": qn.docs[i]["email"],
          "phone": qn.docs[i]['phone'],
          "dob": qn.docs[i]["dob"],
          "image": qn.docs[i]["image"],
          "details": qn.docs[i]["details"],
          "title": qn.docs[i]["title"],
          "location": qn.docs[i]["location"],
        });
        // print(_products[i]["image"]);
        // Fluttertoast.showToast(msg: qn.docs[i]["email"]);
      }
    });

    return qn.docs;
  }

  bool _loading = false;
  int offset = 0;
  int time = 800;

  @override
  void initState() {


    _loading = true;
    Timer(Duration(seconds: 3), () => {
      setState(() {
        _loading = false;
      })
    });

    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          "Found Items",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.black),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  ).catchError(
                        (error) => Fluttertoast.showToast(msg: "Something is wrong"),
                  )

                  .catchError((error)=>Fluttertoast.showToast(msg: "Something is wrong")));
            },
          ),
        ],
      ),
      body: (_products.length>0)? Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: AppColors.deep_orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIconColor: AppColors.deep_orange,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search items here",
                      hintStyle: TextStyle(fontSize: 15.sp),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => SearchItem()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                // this is for the grid view
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: GridView.builder(
                        // scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.601,
                        ),
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => FoundItemDetails(_products[index])),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                elevation: 3,
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.1,
                                      child: (_loading)
                                          ? Container(
                                        color: Colors.white,
                                        child: SafeArea(
                                          child: ListView.builder(
                                            padding: EdgeInsets.all(5),
                                            itemCount: 2,
                                            itemBuilder: (BuildContext context, int index) {
                                              offset += 5;
                                              time = 800 + offset;
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                child: Shimmer.fromColors(
                                                  highlightColor: Colors.white,
                                                  baseColor: Colors.grey,
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 0),
                                                    height: 350,
                                                    width: 270,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                  ),
                                                  period: Duration(milliseconds: time),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                          : Container(
                                        color: Colors.yellow,
                                        child: Image.network(
                                          _products[index]["image"],
                                          // "null"
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                                        child: Column(
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
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
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      "${_products[index]["title"]}".toUpperCase(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
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
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        text: "${_products[index]["location"].toString()}".substring(0, 1).toUpperCase(),
                                                        children: [
                                                          TextSpan(
                                                            text: "${_products[index]["location"].toString()}".substring(1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) :  Center(
        child: Text(
          'No lost item are found',
          style: TextStyle(fontSize: 24),
        ),
      ),

    );
  }
}
