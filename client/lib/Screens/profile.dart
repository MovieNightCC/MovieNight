import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:movie_night/screens/addPairPage.dart';
import 'package:movie_night/screens/onboardsplash.dart';
import './sign_in.dart';

import 'auth.dart';
import './swiper.dart';
import './matches.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
    static String routeName = "/splash";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
// Image Picker
    File _image; // Used only if you need a single picture
    Object profileimg = NetworkImage(userIcon);

    Future getImage(bool gallery) async {
      ImagePicker picker = ImagePicker();
      PickedFile pickedFile;
      // Let user select photo from gallery
      if (gallery) {
        pickedFile = await picker.getImage(
          source: ImageSource.gallery,
        );
      }
      // Otherwise open camera to get new photo
      else {
        pickedFile = await picker.getImage(
          source: ImageSource.camera,
        );
      }

      Future<String> uploadFile(File _image) async {
        var fireBaseRef =
            FirebaseStorage.instance.ref('${basename(_image.path)}');
        await fireBaseRef.putFile(_image);
        print('File Uploaded');
        final returnURL = await fireBaseRef.getDownloadURL();
        print("returnURL $returnURL");
        return returnURL;
      }

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc("$userName");

      Future<void> saveImages(File _image, DocumentReference ref) async {
        String imageURL = await uploadFile(_image);
        print('imageurl is: $imageURL');
        await ref.update({
          "userIcon": "$imageURL",
        });
      }

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print("image is $_image");
          profileimg = Image.file(_image);
          saveImages(_image, userRef);
        } else {
          print("image is $_image");
          print('No image selected.');
        }
      });
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: 35,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image:
                        DecorationImage(fit: BoxFit.cover, image: profileimg)),
              ),
              userInfoElement(displayName),
              userInfoElement(userName),
              userInfoElement(userPair),
              userInfoElement(userEmail),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPairPage()));
                },
                child: Text("Add a partner"),
              ),
              RaisedButton(
                  child: Text("Sign Out"),
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                   Navigator.push(context,
                      MaterialPageRoute(builder: (context) => App()));
                }),
              RaisedButton(
                onPressed: () {
                  print('$userEmail tried to retrieve email');
                  launch('https://movie-night.flycricket.io/privacy.html');
                },
                child: Text("Privacy Policy"),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  getImage(true);
                },
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[200],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies_outlined), label: 'Swipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: 'Matches'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Swiper()));
          }
          if (_currentIndex == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Matches()));
          }
        },
      ),
    );
  }
}

Widget userInfoElement(String input) {
  return Container(
    child: Text(input,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.bold)),
  );
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue[200];
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
