import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';

import '../../home_screen.dart';

class CreateGroup extends StatefulWidget {
  List<Map<String, dynamic>> membersList = [];

  CreateGroup({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isloading = false;

  void createGrop() async {
    setState(() {
      isloading = true;
    });
    String groupId = Uuid().v1();
    await _firestore
        .collection('groups')
        .doc(groupId)
        .set({'members': widget.membersList, 'id': groupId});
    // to show the group to other user
    for (var i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];
      await _firestore
          .collection('usersss')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({'name': _groupName.text, 'id': groupId});
    }
    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created this Group.",
      "type": "notify"
    });
    print(_auth.currentUser);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Name'),
      ),
      body: isloading
          ? Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: "Enter Group Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: createGrop,
                  child: const Text("Create Group"),
                ),
              ],
            ),
    );
  }
}
