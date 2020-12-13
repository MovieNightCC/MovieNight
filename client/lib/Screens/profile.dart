import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:neon/neon.dart';
import './addPairPage.dart';
import './swiper.dart';
import './auth.dart';
import './matches.dart';

import 'package:provider/provider.dart';
import '../main.dart';
import 'DummyMatches.dart';

class Profile extends StatefulWidget {
  static String routeName = "/splash";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(25),
                child: Positioned(
                    top: 15,
                    child: Neon(
                      text: '$displayName',
                      color: Colors.pink,
                      fontSize: 35,
                      font: NeonFont.Membra,
                      flickeringText: false,
                    )),
              ),
              ProfilePicture(),
              UserInfoSection(),
              Padding(
                padding: EdgeInsets.all(10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Text(
                      "Link with your partner",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xffA058CB),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPairPage()));
                    },
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  color: Color(0xffA058CB),
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => App()));
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                      title: new Text("Alert",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      content: new Text("Are you sure?",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('No, go back',
                                              style: TextStyle(
                                                  color: Colors.pink)),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Yes, delete my account',
                                              style: TextStyle(
                                                  color: Colors.pink)),
                                          onPressed: () {
                                            //placeholder for delete user function
                                          },
                                        )
                                      ],
                                    ));
                          },
                        ),
                      ])),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xffA058CB),
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
            if (userPair == "") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DummyMatches()));
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Matches()));
            }
          }
        },
      ),
    );
  }
}

Widget profileInfo() {
  return Column(
    children: <Widget>[
      Text('$userEmail',
          style: TextStyle(
              height: 1.5, fontWeight: FontWeight.bold, fontSize: 20)),
      Text('in $userPair',
          style: TextStyle(
              height: 1.5, fontWeight: FontWeight.bold, fontSize: 20)),
    ],
  );
}

class UserInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userName)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("User does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          userPair = snapshot.data["pairName"];
          if (userPair == "") {
            return Column(
              children: <Widget>[
                Text('$userEmail',
                    style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text('currently not in a pair',
                    style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Text('$userEmail',
                    style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text('in $userPair',
                    style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            );
          }
        });
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xffA058CB);
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

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File _image; // Used only if you need a single picture
  String profileimg = userIcon;
  @override
  Widget build(BuildContext context) {
// Image Picker
    print("profile image $profileimg");
    Future getImage(bool gallery) async {
      ImagePicker picker = ImagePicker();
      PickedFile pickedFile;
      // Let user select photo from gallery
      if (gallery) {
        pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          maxHeight: MediaQuery.of(context).size.width / 2,
          maxWidth: MediaQuery.of(context).size.width / 2,
        );
      }
      // Otherwise open camera to get new photo
      else {
        pickedFile = await picker.getImage(
          source: ImageSource.camera,
          maxHeight: MediaQuery.of(context).size.width / 2,
          maxWidth: MediaQuery.of(context).size.width / 2,
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

        setState(() {
          profileimg = imageURL;
          userIcon = imageURL;
        });
        print('imageurl is: $imageURL');
        await ref.update({
          "userIcon": "$imageURL",
        });
      }

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print("image is $_image");
          //profileimg = Image.file(_image);
          saveImages(_image, userRef);
        } else {
          print("image is $_image");
          print('No image selected.');
        }
      });
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(profileimg),
              )),
        ),
        CircleAvatar(
          backgroundColor: Color(0xff5B38BA),
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
      ],
    );
  }
}
