import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vix_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authenticate = FirebaseAuth.instance;
  final _cloudStore = FirebaseFirestore.instance;
  late String userMessage;
  final textController = TextEditingController();

  //we need to get the current loggedInUser's email sending a message in this method
  void getUser() {
    try {
      final currentUser = _authenticate.currentUser;
      if (currentUser != null) {
        loggedInUser = currentUser;
        // print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }
  // void storedMessageStreams() async {
  //   await for (var snapshot in _cloudStore.collection('messages').snapshots()) {
  //     for (var messages in snapshot.docs) {
  //       print(messages.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // storedMessageStreams();
                _authenticate.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.teal.shade600,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _cloudStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data?.docs
                      .reversed; /*flutter inbuilt snapshot property*/
                  List<Widget> textWidgets = [];
                  for (var message in messages!) {
                    var resultText = message.data()! as Map;
                    final messageText = resultText['text'];
                    var resultSender = message.data()! as Map;
                    final messageSender = resultSender['sender'];

                    final currentUser = loggedInUser?.email;
                    final messageOwner = MessageField(
                      text: messageText,
                      sender: messageSender,
                      itsMe: currentUser == messageSender,
                      alignment: currentUser == messageSender,
                      border: currentUser == messageSender,
                    );
                    textWidgets.add(messageOwner);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      children: textWidgets,
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        userMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      textController.clear();
                      _cloudStore.collection('messages').add(
                        {'sender': loggedInUser?.email, 'text': userMessage},
                      );
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final String text;
  final String sender;
  final bool itsMe;
  final bool alignment;
  final bool border;
  const MessageField(
      {Key? key,
      required this.text,
      required this.sender,
      required this.itsMe,
      required this.alignment,
      required this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            alignment ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.white70),
          ),
          Material(
            elevation: 6.0,
            borderRadius: border
                ? const BorderRadius.only(
                    topLeft: Radius.circular(31.0),
                    bottomLeft: Radius.circular(31.0),
                    bottomRight: Radius.circular(31.0))
                : const BorderRadius.only(
                    topRight: Radius.circular(31.0),
                    bottomLeft: Radius.circular(31.0),
                    bottomRight: Radius.circular(31.0)),
            color: itsMe ? Colors.white : Colors.teal,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Text(
                text,
                style: TextStyle(
                  color: itsMe ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
