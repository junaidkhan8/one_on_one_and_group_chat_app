import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;

  final String chatRoomId;

  ChatRoom({required this.userMap, required this.chatRoomId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _message = TextEditingController();
  var _endmessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    print('onsend mess pr agaya ha');
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'send_by': _auth.currentUser!.displayName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp()
      };

      await _firestore
          .collection('chatroom')
          .doc(_auth.currentUser!.uid)
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      _message.clear();
    } else {
      print('enter some text');
    }
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('users')
              .doc(widget.userMap['uid'])
              .snapshots(), 
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(widget.userMap['name']),
                    
                    Text(snapshot.data![
                        'status']) 
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('whatsappdark.jpg'), fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(_auth.currentUser!.uid)
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;

                        return message(size, map);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: Colors.blue, width: 3)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration:
                          const InputDecoration(labelText: 'Send Message...'),
                      onChanged: (value) {
                        setState(() {
                          _endmessage = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed:
                        _endmessage.trim().isEmpty ? null : onSendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Container(
      //   // height: size.height / 10,
      //   width: size.width,
      //   alignment: Alignment.center,
      //   child: SizedBox(
      //     // height: size.height / 12,
      //     width: size.width / 1.1,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(
      //           // height: size.height / 12,
      //           width: size.width / 1.5,
      //           child: Padding(
      //             padding: const EdgeInsets.only(left: 8),
      //             child: TextField(
      //               controller: _message,
      //               decoration: InputDecoration(
      //                 hintText: "Send Message",
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(9.0),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         IconButton(
      //           onPressed:  () {
      //             onSendMessage();
      //           },
      //           icon: const Icon(Icons.send),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget message(Size size, Map<String, dynamic> map) {
    return Row(
      children: [
        Container(
          width: size.width,
          alignment: map['send_by'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: map['send_by'] != _auth.currentUser!.displayName
                  ? Colors.indigoAccent
                  : Colors.blue,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: map['send_by'] != _auth.currentUser!.displayName
                ? const EdgeInsets.only(right: 140, top: 3, bottom: 3, left: 10)
                : const EdgeInsets.only(
                    left: 140, top: 3, bottom: 3, right: 10),
            child: Text(
              map['message'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Text(map['time'].toString())
      ],
    );
  }
}
