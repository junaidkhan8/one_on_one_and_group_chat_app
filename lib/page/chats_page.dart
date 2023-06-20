import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List? userMap;
  // Map<String, dynamic>? userMap;

  @override
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getList() async {
    final result =await _firestore
        .collection('chatroom')
        .where('${_auth.currentUser!.uid}')
        // .doc("${_auth.currentUser!.uid}")
        // .collection('user')
        // .where('id' ,isEqualTo:'${_auth.currentUser!.uid}' )
        .get()
        .then((value) {
      setState(() {
        // userMap = value.data() as List;
        userMap = value.docs;
      //   isLoading = false;
      });
    });
    print(_auth.currentUser!.uid.toString());
      print('${result.data}');
  }

  Widget build(BuildContext context) {
    getList();

    // return Container();
    // getList();
    return StreamBuilder(
      stream: _firestore.collection('chatroom').doc(_auth.currentUser!.uid).collection('user').snapshots(),
      builder: (context,AsyncSnapshot snapshot) {
        // if (!snapshot.hasData) return  Text('Loading...');
        
                  print('==============================================');
        // return ListView.builder(
        //         itemCount: snapshot.data!.docs.length,
        //         itemBuilder: (context, index) {
        //           // DocumentSnapshot doc = snapshot.data.docs[index];
        //           print('++++++++++++++++++++++++++++++++++++++++++++++');
        //           print(snapshot.data[index]);
              //     return ListTile(
              //       title: Text(doc.toString()),
              //     );
              //   },
              // );
        return  ListView(
          children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
            return  ListTile(
              title:  Text(document['name']),
              subtitle:  Text(document['phone']),
            );
         }).toList(),
       );
      },
      );
  }
}
