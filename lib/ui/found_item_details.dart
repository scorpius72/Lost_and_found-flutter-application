import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const/app_colors.dart';
import 'bottom_nav_controller.dart';
import 'bottom_nav_pages/profile.dart';

class FoundItemDetails extends StatefulWidget {
  var _product;
  FoundItemDetails(this._product);

  @override
  State<FoundItemDetails> createState() => _FoundItemDetailsState();
}

class _FoundItemDetailsState extends State<FoundItemDetails> {

  var UserEmail ; // this is the current user email address

  @override
  void initState() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    UserEmail = currentUser?.email;
    // TODO: implement initState
    super.initState();
  }

  // String phoneNumber = ;
  String message = 'Thanks for notifying me';

  void openWhatsAppChat(String phoneNumber, String message) async {
    // Encode the message to ensure it's properly formatted in the URL
    String encodedMessage = Uri.encodeComponent(message);

    // Create the WhatsApp URL with the provided phone number and message
    String url = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    // Check if the WhatsApp application is installed on the device
    if (await canLaunch(url)) {
      // Launch the WhatsApp chat box with the pre-filled message
      await launch(url);
    } else {
      // Handle if WhatsApp is not installed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('WhatsApp Not Installed'),
            content: Text('Please install WhatsApp to continue.'),
            actions: <Widget>[
              FloatingActionButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users-found-items') // Replace with your collection name
                    .doc(UserEmail)
                    .collection('items') // Replace with the ID of the document to delete
                    .doc(UserEmail+widget._product['title'])
                    .delete()
                    .then((value) {
                  // Document successfully deleted
                  print('Document deleted');
                  Fluttertoast.showToast(msg: 'item deleted successfully');
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(builder: (_) => BottomNavController()),
                  );
                })
                    .catchError((error) {
                  // Error occurred while deleting document
                  print('Failed to delete document: $error');
                  Fluttertoast.showToast(msg: 'Failed to delete document: $error');
                });
              },
              icon: Icon(
                Icons.delete,
                color: AppColors.deep_orange,
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
                      aspectRatio: 1,
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
                    Container(
                      width: double.infinity, // Occupies the full width of the screen
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(person_email: widget._product['email']))),
                                child: Text(
                                  "Profile Info",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.deep_orange,
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (() async{
                                  // Fluttertoast.showToast(msg: '+88'+widget._product['phone']);
                                  openWhatsAppChat(widget._product['phone'], message);
                                }),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(

                                      Icons.phone,// Use the WhatsApp icon from the FontAwesomeIcons library
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "WhatsApp",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.deep_orange,
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ),
          )),
    );
  }
}
