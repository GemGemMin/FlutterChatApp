import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // 플러터에서 사용하는 플러그인을 초기화할 때, 이 플러그인의 초기화 메서드가 비동기 방식일 때 문제가 발생함.
  // 플러터에서 Firebase를 사용하기 위해 최초로 불러와야하는 firebase.initializeApp()은 비동기 방식으로 작동한다.
  // firebase.initializeApp 메서드는 플러터와 통신하길 바라지만, runApp 메소드가 호출되기 전에는 플러터 엔진이 초기화되지 않아 접근할 수 없다.
  // 따라서 메인 메소드 내부에서 플러터 엔진과 관련된 파이어베이스 초기화와 같은 비동기 메소드를 사용하려면 플러터 코어인증을 초기화시켜줘야 한다.
  // 이 기능을 수행하는 메소드가 WidgetsFlutterBinding.ensureInitialized 메소드이다.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chatting Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const LoginSignupScreen();
          },
        )
        // authentication state가 바뀔 때 이를 구독하기 위한 세가지 메서드 중 하나가 authStateChanges 메서드임.
        // 다른 메소드로는 idTokenChanges 메서드와, userChanges 메서드가 있다.
        // 로그인이나 로그아웃을 할 때마다 authentication state가 바뀌고, 이때 파이어베이스가 발급해준 토큰을 FirebaseAuth가 관리해준다.
        // 우리는 간단하게 Stream을 authStateChanges 메서드로 구독만 해주면 된다.
        );
  }
}
