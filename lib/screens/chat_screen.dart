import 'package:chatapp/chatting/chat/message.dart';
import 'package:chatapp/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              // Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        child: const Column(
          children: [
            Expanded(
              child: Messages(),
              // Messages 위젯은 리스트뷰를 보여주는데 이 상태로 실행시키면 에러를 발생시키게 된다.
              // Column 내의 리스트뷰가 무조건 화면 내의 모든 공간을 확보해버리기 때문이다.
              // -> 그래서 Messages 위젯을 Expanded 위젯으로 감싸주어야 한다.
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
