import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser; // ?를 붙여 nullable 타입임을 dart에게 알려줌.

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat screen'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                _authentication.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/eyLMAkeiHCsj7jtzcwCZ/message')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // 로딩 중일 때
            }

            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              // 컬렉션 내의 모든 문서에 접근할 수 있음.
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    docs[index]['text'],
                    style: const TextStyle(fontSize: 20.0),
                  ),
                );
              },
            );
          },
          // snapshot 메소드는 스트림을 반환해주기 때문에, 데이터가 바뀔 때마다 새로운 value값을 전달해준다.
        ));
  }
}
