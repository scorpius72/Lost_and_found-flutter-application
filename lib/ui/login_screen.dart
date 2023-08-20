import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/ui/bottom_nav_controller.dart';
import 'package:lost_and_found/ui/forget_password.dart';
import 'package:lost_and_found/ui/registration_screen.dart';

import '../const/app_colors.dart';
import '../widgets/customButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signIn()async{

    if (_emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Your Email Addess");
      return;
    }
    if (_passwordController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please Enter Your Email Addess");
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,    // user given email address
          password: _passwordController.text // user given password
      );
      var authCredential = credential.user;
      print(authCredential?.uid);
      if (authCredential!.uid.isNotEmpty){  // this will check the user login info is right or wrong
        Navigator.pushReplacement(  // this function will navigate the user to the Next page
          context,
          CupertinoPageRoute(builder: (_) => BottomNavController()),
        );

      }
      else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) { // this will catch error like invalid email or password
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.light,
                        color: Colors.transparent,
                      ),
                    ),
                    Text(
                      "Sign In",
                      style: TextStyle(fontSize: 40.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 22.sp, color: AppColors.deep_orange),
                        ),
                        Text(
                          "Glad to see you back my buddy.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
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
                                  Icons.lock_outline,
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
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: "password must be 6 character",
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xFF414041),
                                  ),
                                  labelText: 'PASSWORD',
                                  labelStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.deep_orange,
                                  ),
                                  suffixIcon: _obscureText == true
                                      ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        size: 20.w,
                                      ))
                                      : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        size: 20.w,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20.h,
                        ),
                        Wrap(
                          children: [
                            Text(
                              "Forget Password ?",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                " Reset Password ",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deep_orange,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()));
                              },
                            )
                          ],
                        ),

                        SizedBox(
                          height: 20.h,
                        ),
                        // elevated button
                        customButton("Sign In", (){
                          signIn();
                        },),
                        SizedBox(
                          height: 20.h,
                        ),
                        Wrap(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                " Sign Up",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deep_orange,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
