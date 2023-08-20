import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/ui/bottom_nav_pages/found_item.dart';
import 'package:lost_and_found/ui/bottom_nav_pages/lost_item.dart';
import 'package:lost_and_found/ui/bottom_nav_pages/profile.dart';

import '../const/app_colors.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {




  final _pages = [ Lost(), Found(), Profile(person_email: FirebaseAuth.instance.currentUser!.email??"",)];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [

          BottomNavigationBarItem(
              icon: Icon(Icons.directions), label: "Lost",),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_weak),
              label: "Found",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}


