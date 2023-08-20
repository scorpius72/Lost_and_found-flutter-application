import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/const/app_colors.dart';
import 'package:lost_and_found/ui/add_lost_items.dart';
import 'package:lost_and_found/ui/lost_item_details.dart';
import 'package:lost_and_found/ui/search_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../login_screen.dart';

class Lost extends StatefulWidget {
  const Lost({Key? key}) : super(key: key);

  @override
  State<Lost> createState() => _LostState();
}

class _LostState extends State<Lost> {
  // this is for get data from database
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchProducts() async {
    QuerySnapshot qn =
    await _firestoreInstance.collection("lost-items-data").get(); // firebase lost item data location
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({  // add all the data to the _product list
          "email": qn.docs[i]["email"],
          "dob": qn.docs[i]["dob"],
          "image": qn.docs[i]["image"],
          "details": qn.docs[i]["details"],
          "title": qn.docs[i]["title"],
          "location": qn.docs[i]["location"],
        });
        // print(_products[i]["image"]);
        // Fluttertoast.showToast(msg: _products][i]["image"].toString());
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
    Timer(Duration(seconds: 4), () => {
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
          "Lost Items",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              )

                  .catchError((error) =>
                  Fluttertoast.showToast(msg: "Something is wrong")));
            },
          ),
        ],
      ),
      body: Scaffold(
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
                    padding: EdgeInsets.all(16.w),
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
                            onTap: () => Navigator.push( // navigate the user to the LostItemDetails Window
                              context,
                              MaterialPageRoute(builder: (_) => LostItemDetails(_products[index])),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Card(
                                elevation: 3,
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.12,
                                      child: (_loading)
                                          ? Container(
                                        color: Colors.white,
                                        child: SafeArea(
                                          child: ListView.builder(
                                            padding: EdgeInsets.all(5.w),
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
                                                    margin: EdgeInsets.only(right: 0.h),
                                                    height: 350,
                                                    width: 270,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius: BorderRadius.circular(16.h),
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
                                        borderRadius: BorderRadius.circular(5.w),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 0.w),
                                        child: Column(
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(5.w),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.w),
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
                                                  SizedBox(width: 5.h),
                                                  Expanded(
                                                    child: Text(
                                                      "${_products[index]["title"]}".toUpperCase(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(5.w),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.w),
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
                                                  SizedBox(width: 5.w),
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
                                            SizedBox(height: 3.h),
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
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => AddLostItems()));
        },
        backgroundColor: AppColors.deep_orange,
        child: Icon(Icons.add),
      ),
    );
  }
}
