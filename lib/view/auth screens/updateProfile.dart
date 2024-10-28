import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this line
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String username;

  UpdateProfileScreen({required this.username, Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;
  String error = '';
  String imageUrl = '';
  File? logoImage;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.username;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          _nameController.text = userDoc['username'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic> updatedData = {
          'username': _nameController.text.trim(),
        };

        if (logoImage != null) {
          // Upload the new image to Firebase Storage
          String fileName = 'profile_images/${user.uid}.jpg';
          Reference storageRef =
              FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = storageRef.putFile(logoImage!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();

          updatedData['userImage'] = uploadedImageUrl;
        }

        // Update the user's Firestore document
        await _firestore.collection('users').doc(user.uid).update(updatedData);

        if (mounted) {
          setState(() {
            isLoading = false;
          });

          // Show success message or navigate to another screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } else {
        setState(() {
          error = 'No user is currently signed in.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error updating profile: $e';
        isLoading = false;
      });
    }
  }

  Future<void> getImage() async {
    ImagePicker picker = ImagePicker();
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      logoImage = File(imageFile!.path);
      debugPrint("image path: ${imageFile!.path}");
      setState(() {});
    }
    if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No File selected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FutureBuilder<DocumentSnapshot>(
                        future: users
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: size.width * .14,
                                      backgroundColor: primaryColor,
                                      child: logoImage == null
                                          ? snapshot.data!['userImage'] == null ||
                                                  snapshot
                                                      .data!['userImage']!.isEmpty
                                              ? ClipOval(
                                                  child: Image.asset(
                                                    image_profile,
                                                    height: size.width * .24,
                                                    width: size.width * .24,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.network(
                                                  snapshot.data!['userImage']
                                                      .toString(),
                                                  height: size.width * .24,
                                                  width: size.width * .24,
                                                  fit: BoxFit.cover,
                                                ))
                                          : ClipOval(
                                              child: Image.file(
                                                File(logoImage!.path).absolute,
                                                height: size.width * .24,
                                                width: size.width * .24,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      onPressed: () {
                                        getImage();
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                      color: whiteColor,
                                      iconSize: 15,
                                    ))
                              ],
                            );
                          } else {
                            return const Column(
                              children: [
                                Center(child: CircularProgressIndicator()),
                              ],
                            );
                          }
                        },
                      ).paddingTop(40),
                    ),
                    text("Name", fontSize: 14.0),
                    textField(
                      hint: "Name",
                      controller: _nameController,
                      labell: text("Name"),
                      maxline: 1,
                    ).paddingTop(5),
                    const SizedBox(height: 20),
                    elevatedButton(context,
                            loading: isLoading,
                            onPress: _updateUserProfile,
                            child: text("Update Profile", textColor: white))
                        .paddingTop(size30),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
