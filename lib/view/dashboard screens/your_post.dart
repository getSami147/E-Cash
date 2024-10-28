import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/cash_to_E_Money.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/update_post.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class YourPosts extends StatefulWidget {
  @override
  _YourPostsState createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  String _error = '';

  // Assuming you have the current user's UID stored in a variable.

  @override
  void initState() {
   final userViewModel=Provider.of<UserViewModel>(context,listen: false);


    super.initState();
    _queryUserPosts(userViewModel.currentLocation!.latitude??0.0,
                    userViewModel.currentLocation!.longitude??0.0,);
  }

  void _queryUserPosts(double lat, double lng) {
   final userViewModel=Provider.of<UserViewModel>(context,listen: false);
    var collectionReference = _firestore.collection('posts');

    collectionReference.where("userId", isEqualTo: userViewModel.userId.toString()).snapshots().listen((snapshot) async {
      List<Map<String, dynamic>> postsWithUserDetails = [];

      for (var document in snapshot.docs) {
        var postData = document.data();

        // Fetch user details
        var userDoc = await _firestore.collection('users').doc(userViewModel.userId.toString()).get();
        var userData = userDoc.data();

        if (userData != null) {
          postsWithUserDetails.add({
            'post': postData,
            'user': userData,
          });
        }
      }

      setState(() {
        _posts = postsWithUserDetails;
        _isLoading = false;
        if (_posts.isEmpty) {
          _error = 'No posts found for the current user.';
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _error = 'Error querying posts: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  final firestore = FirebaseFirestore.instance.collection('posts');

    
    return Scaffold(
      appBar: AppBar(
        title: text('User Posts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _posts.isEmpty
                  ? const Center(child: Text('No posts found for the current user.'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _posts.length,
                            padding: const EdgeInsets.only(bottom: size10),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var postData = _posts[index]['post'];
                              var userData = _posts[index]['user'];
                              return requestCash(
                                isUpdate: true,
                                title: 'Name: ${userData['username']}',
                                desc: '${postData['description']}',
                                type: 'Payment Source: ${postData['paymentSource']}',
                                amount: 'Amount: ${postData['amount']}',
                                deletOnTap: () async {
                                //OnPress Delete
                                 await firestore.doc(postData["_id"]).delete().then((value) {
                                  utils().toastMethod("Your post has been deleted succussfuly.");
                                 });
                                  
                                },
                                updateOnTap: () {
                                  //OnPress update
                                  UpdatePostScreen(postdata:postData,).launch(context);
                                },
                              ).paddingBottom(size15);
                            },
                          ),
                        )
                      ],
                    ).paddingAll(size20),
    );
  }
}

//

