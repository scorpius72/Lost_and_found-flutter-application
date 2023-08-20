import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_and_found/const/app_colors.dart';

import 'lost_item_details.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({Key? key}) : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  var inputText = "";
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
      body: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) {
                    setState(() {
                      inputText = val;
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: AppColors.deep_orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Search items here",
                    hintStyle: TextStyle(fontSize: 15.sp),
                    prefixIconColor: AppColors.deep_orange,
                    suffixIconColor: AppColors.deep_orange,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        inputText = "";
                      },
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("lost-items-data")
                          .where("title", isGreaterThanOrEqualTo: inputText)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
                          );
                        }

                        return IntrinsicHeight(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.601,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LostItemDetails(data))),
                                child: Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.1,
                                        child: Container(
                                          color: Colors.yellow,
                                          child: Image.network(
                                            data["image"],
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
                                                        data["title"].toUpperCase(),
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
                                                          text: data['location'].toString().substring(0, 1).toUpperCase(),
                                                          children: [
                                                            TextSpan(
                                                              text: data['location'].toString().toString().substring(1),
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
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
