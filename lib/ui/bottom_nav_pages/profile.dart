import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/ui/login_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../const/app_colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.person_email}) : super(key: key);
  final person_email;
  @override
  State<Profile> createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {

  @override
  void initState() {
    // Fluttertoast.showToast(msg: widget.person_email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (FirebaseAuth.instance.currentUser!.email!= widget.person_email) ? AppBar(
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

          title: Text(
            "Profile",
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
                )).catchError((error) =>
                    Fluttertoast.showToast(msg: "Something is wrong"),
                );
              },
            ),
          ],

        ):AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          title: Text(
            "Profile",
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
                    MaterialPageRoute(builder: (_) => LoginScreen()))
                    .catchError((error) =>
                    Fluttertoast.showToast(msg: "Something is wrong")));
              },
            ),
          ],

        ),


        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),

          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user-form-data")
                .where("email", isGreaterThanOrEqualTo: widget.person_email)
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

              return Column(
                children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!.docs[0].get('photo')),
                        ),
                        Positioned(
                          right: -16,
                          bottom: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xFFF5F6F9),
                                ),
                                onPressed: () {},
                                child:  Icon(Icons.person, color: Colors.black),

                                ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // this is for every single option

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () => {},
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.person, color: AppColors.deep_orange),
                            onPressed: () {},
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                                  snapshot.data!.docs[0].get('name')
                              )),

                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () => {},
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.email, color: AppColors.deep_orange),
                            onPressed: () {},
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                                  snapshot.data!.docs[0].get('email')
                              )),

                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () => {},
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.phone, color: AppColors.deep_orange),
                            onPressed: () {},
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                                  snapshot.data!.docs[0].get('phone')
                              )),

                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () => {},
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.person, color: AppColors.deep_orange),
                            onPressed: () {},
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                                  snapshot.data!.docs[0].get('gender')
                              )),

                        ],
                      ),
                    ),
                  ),

                ],
              );

            },

          ),

        )


    );


  }
}
