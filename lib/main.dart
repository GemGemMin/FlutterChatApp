import 'package:chatapp/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
        home: const LoginSignupScreen());
  }
}
