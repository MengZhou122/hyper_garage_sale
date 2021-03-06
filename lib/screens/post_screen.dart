import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hypergaragesale/components/error_notification.dart';
import 'package:hypergaragesale/components/post_data.dart';
import 'package:hypergaragesale/components/rounded_button.dart';
import 'package:hypergaragesale/components/text_card.dart';
import 'package:hypergaragesale/screens/camera_screen.dart';
import 'package:hypergaragesale/screens/item_list_screen.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PostScreen extends StatefulWidget {
  static const String id = 'post_screen';
  final String category;
  PostScreen({this.category});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  PostData newPost = PostData();
  Location userLocation = Location();
  LocationData _locationData;
  bool showSpinner = false;
  List<Widget> thumbnails = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    newPost.category = widget.category;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateAddress() async {
    print('in updateAddress block');
    try {
      _locationData = await userLocation.getLocation();
      Coordinates coordinates =
          Coordinates(_locationData.latitude, _locationData.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print('${first.featureName}');
      newPost.address = first.addressLine;
      newPost.latitude = _locationData.latitude;
      newPost.longitude = _locationData.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    for (int i = 0; i < newPost.pictures.length; i++) {
      var timeKey = new DateTime.now();

      StorageReference postImageRef = FirebaseStorage.instance
          .ref()
          .child("zm_post_images")
          .child(timeKey.toString() + ".png");

      StorageUploadTask uploadTask =
          postImageRef.putFile(File(newPost.pictures[i]));

      await uploadTask.onComplete;
//main problem is here!!!
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      //String imageUrl = await postImageRef.getDownloadURL();

      newPost.urls.add(imageUrl);
    }
  }

  Future<void> uploadPost() async {
    try {
      await _firestore.collection(widget.category).add({
        'user': loggedInUser.email,
        'title': newPost.title,
        'price': newPost.price,
        'description': newPost.description,
        'address': newPost.address,
        'longitude': newPost.longitude.toString(),
        'latitude': newPost.latitude.toString(),
        'picture0': newPost.urls.length < 1 ? ' ' : newPost.urls[0],
        'picture1': newPost.urls.length < 2 ? ' ' : newPost.urls[1],
        'picture2': newPost.urls.length < 3 ? ' ' : newPost.urls[2],
        'picture3': newPost.urls.length < 4 ? ' ' : newPost.urls[3],
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text(' New  Post'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 5.0),
                TextCard(
                  label: 'Title',
                  textIn: (newTitle) {
                    newPost.title = newTitle;
                  },
                  controller: titleController,
                ),
                SizedBox(height: 10.0),
                TextCard(
                  label: 'Price',
                  price: true,
                  textIn: (newPrice) {
                    newPost.price = newPrice;
                  },
                  controller: priceController,
                ),
                SizedBox(height: 10.0),
                TextCard(
                  label: 'Description',
                  description: true,
                  textIn: (newDescription) {
                    newPost.description = newDescription;
                  },
                  controller: descriptionController,
                ),
                SizedBox(height: 10.0),
                //Text('${newPost.address} ${newPost.latitude} ${newPost.longtitude}'),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    height: 80.0,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white60),
                    child: Wrap(children: [
                      Text('${newPost.address}',
                          style: TextStyle(fontSize: 16.0)),
                    ])),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(Icons.room),
                      heroTag: 'address',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        await _updateAddress();
                        print('address updated!');
                        setState(() {
                          showSpinner = false;
                          print(
                              '${newPost.address}, ${newPost.latitude}, ${newPost.longitude}');
                        });
                      },
                    ),
                    Text(
                        newPost.pictures.length == 0
                            ? '        Add a Picture 👉'
                            : '  Add another Picture 👉',
                        style: TextStyle(fontSize: 18.0)),
                    FloatingActionButton(
                      child: Icon(Icons.add_a_photo),
                      heroTag: 'picture',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (newPost.pictures.length == 4) {
                          showErrorNotification(context, 'Maximun 4 Pictures!');
                        } else {
                          final cameras = await availableCameras();
                          final camera = cameras.first;
                          if (cameras == null || cameras.length == 0) {
                            print('No Camera!!!!');
                          }
                          final imagePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(camera: camera),
                            ),
                          );
                          print(imagePath);
                          if (imagePath != null) {
                            newPost.pictures.add(imagePath);

                            Container pictureC = Container(
                              height: 120.0,
                              width: 80.0,
                              padding: const EdgeInsets.all(1.0),
                              child: Image.file(File(imagePath)),
                            );
                            thumbnails.add(pictureC);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: thumbnails,
                ),
                SizedBox(height: 5.0),
                RoundedButton(
                    title: 'Post',
                    color: Colors.lightBlueAccent,
                    width: 120,
                    onPressed: () async {
                      if (newPost.title == '') {
                        showErrorNotification(context, 'Please Give a Title!');
                      } else if (newPost.price == '') {
                        showErrorNotification(
                            context, 'Please give a Estimate Price!');
                      } else if (newPost.address == '👇 Get Address') {
                        showErrorNotification(
                            context, 'Please Add Address Info!');
                      } else {
                        setState(() {
                          showSpinner = true;
                        });
                        await uploadImage();
                        await uploadPost();
                        titleController.clear();
                        priceController.clear();
                        descriptionController.clear();
                        thumbnails = [];
                        newPost = PostData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemListScreen(
                              category: widget.category,
                            ),
                          ),
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
