import 'package:chat_screen_for/group_chat/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;
  GroupChatRoom({required this.groupChatId,required this.groupName, Key? key}) : super(key: key);
  final TextEditingController _message = TextEditingController();
  String currentUserName = "User1";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async{
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "send_by": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time":FieldValue.serverTimestamp()
      };
      _message.clear();
      await _firestore.collection('groups').doc(groupChatId).collection('chats').add(chatData);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Name'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GroupInfo(groupId: groupChatId,groupName: groupName,),
                ));
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: size.height / 1.27,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('groups')
                      .doc(groupChatId)
                      .collection('chats')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String,dynamic> chatMap=snapshot.data!.docs[index].data() as Map<String,dynamic>;
                          return messageTile(size, chatMap);
                        },
                      );
                    } else{
                      return Container();
                    }
                  },
                )),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(34),
                   border: Border.all(color: Colors.blue , width: 3)
                   ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration:
                          const InputDecoration(labelText: 'Send Message...'),
                      // onChanged: (value) {
                      //   setState(() {
                      //     _endmessage = value;
                      //   });
                      // },
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: onSendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(
      builder: (_) {
        if (chatMap['type'] == 'text') {
          return Container(
            width: size.width,
            alignment: chatMap['send_by'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 100,
              vertical: size.height / 400,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: chatMap['send_by'] != _auth.currentUser!.displayName
                  ? const EdgeInsets.only(
                      right: 140, top: 3, bottom: 3, left: 10)
                  : const EdgeInsets.only(
                      left: 140, top: 3, bottom: 3, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatMap['send_by'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (chatMap['type'] == 'img') {
          return Container(
            width: size.width,
            alignment: chatMap['send_by'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 100,
              vertical: size.height / 400,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: chatMap['send_by'] != _auth.currentUser!.displayName
                  ? const EdgeInsets.only(
                      right: 140, top: 3, bottom: 3, left: 10)
                  : const EdgeInsets.only(
                      left: 140, top: 3, bottom: 3, right: 10),
              height: size.height / 2,
              child: Image.network(chatMap['message']),
            ),
          );
        } else if (chatMap['type'] == 'notify') {
          return Container(
            color: Colors.red,
            width: size.width,
            alignment: Alignment.center,
            child: Center(
              child: Container(

                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black38),
                child: Text(
                  chatMap['message'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
