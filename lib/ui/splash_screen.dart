import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_and_found/ui/bottom_nav_controller.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var auth  = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin()async {
    auth.authStateChanges().listen((User ? user) {
        if (user!=null && mounted){
          setState(() {
            // Fluttertoast.showToast(msg: "yes");
            isLogin = true;
          });
        }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    Timer(const Duration(seconds: 3), () {
      if (isLogin) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavController()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Text("Lost And Found", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 38.sp),),
              SizedBox(height: 20.h,),
              CircularProgressIndicator(color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}
