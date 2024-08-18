import 'package:chatapp/config/palette.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();
  // 전송 버튼을 눌렀을 때 TextFormField의 내용을 전달하기 위해 GlobalKey를 사용
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  final _authentication = FirebaseAuth.instance;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    // validate 메소드를 통해 모든 텍스트 폼 필드의 validator를 작동시킬 수 있다.
    if (isValid) {
      _formKey.currentState!.save();
      // save 메소드가 호출되면 폼 전체의 state값을 저장하게 되는데 이 과정에서 모든 텍스트 폼 필드가 가지고 있는 onSaved 메소드를 작동시키게 된다.
      // 그래서 각 텍스트 폼 필드에서 onSaved 메소드를 추가해주어야 한다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // 스크린을 터치했을 때 소프트 키보드가 사라지도록 하기 위한 설정
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/red.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 90,
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Welcome',
                          style: const TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? ' to chat' : ' back',
                              style: const TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        isSignupScreen
                            ? 'Signup to continue'
                            : 'Signin to continue',
                        style: const TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // 배경 Positioned 필드
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: 180,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(20),
                height: isSignupScreen ? 280 : 250,
                width: MediaQuery.of(context).size.width - 40,
                // width를 숫자로 설정하면 각 디바이스마다 width를 다르게 설정해주어야 하므로, MediaQuery.of를 이용해서 각 디바이스의 width값을 구할 수 있다.
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    // 그림자 효과를 주기 위해 다양한 색의 조합이 필요하므로 리스트 자료형 구조를 가지고 있다.
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    // 경고 문구나 키보드 입력창이 떴을 때 화면을 가리지 않도록 SingleChildScrollView로 감싸준다.
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(1),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // onSaved는 사용자가 입력한 벨류 값을 저장하는 기능을 가지고 있다.
                                    userName = value!;
                                  },
                                  // TextField에서 값을 입력 받으면 기본적으로 Text Editing Controller를 사용해야 함.
                                  // 하지만 TextFormField를 사용하면 쉽게 validation 값 등을 받아올 수 있는 장점이 있다.
                                  onChanged: (value) {
                                    userName = value;
                                  },

                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // focusedBorder는 텍스트 필드가 선택이 되었을 때 Border line을 보여주는 기능을 함
                                      // focusedBorder를 사용하지 않으면 텍스트를 입력할 때 Border가 사라짐.
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: 'User name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    // TextFormField의 사이즈를 바꿀 수 있음
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType
                                      .emailAddress, // @가 있는 키보드 자판으로 바뀜.
                                  key: const ValueKey(2),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  // TextField에서 값을 입력 받으면 기본적으로 Text Editing Controller를 사용해야 함.
                                  // 하지만 TextFormField를 사용하면 쉽게 varidation 값 등을 받아올 수 있는 장점이 있다.
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_rounded,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // focusedBorder는 텍스트 필드가 선택이 되었을 때 Border line을 보여주는 기능을 함
                                      // focusedBorder를 사용하지 않으면 텍스트를 입력할 때 Border가 사라짐.
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    // TextFormField의 사이즈를 바꿀 수 있음
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true, // password가 *표시로 나타남.
                                  key: const ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      // Firebase에서는 password가 최소 6글자 이상이 입력되어야 한다.
                                      return 'Password must be at least 7 characters long';
                                    }
                                    return null;
                                  },
                                  // TextField에서 값을 입력 받으면 기본적으로 Text Editing Controller를 사용해야 함.
                                  // 하지만 TextFormField를 사용하면 쉽게 varidation 값 등을 받아올 수 있는 장점이 있다.
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // focusedBorder는 텍스트 필드가 선택이 되었을 때 Border line을 보여주는 기능을 함
                                      // focusedBorder를 사용하지 않으면 텍스트를 입력할 때 Border가 사라짐.
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    // TextFormField의 사이즈를 바꿀 수 있음
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  // TextField에서 값을 입력 받으면 기본적으로 Text Editing Controller를 사용해야 함.
                                  // 하지만 TextFormField를 사용하면 쉽게 varidation 값 등을 받아올 수 있는 장점이 있다.
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_rounded,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // focusedBorder는 텍스트 필드가 선택이 되었을 때 Border line을 보여주는 기능을 함
                                      // focusedBorder를 사용하지 않으면 텍스트를 입력할 때 Border가 사라짐.
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    // TextFormField의 사이즈를 바꿀 수 있음
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key: const ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      // Firebase에서는 password가 최소 6글자 이상이 입력되어야 한다.
                                      return 'Password must be at least 7 characters long';
                                    }
                                    return null;
                                  },
                                  // TextField에서 값을 입력 받으면 기본적으로 Text Editing Controller를 사용해야 함.
                                  // 하지만 TextFormField를 사용하면 쉽게 varidation 값 등을 받아올 수 있는 장점이 있다.
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // focusedBorder는 텍스트 필드가 선택이 되었을 때 Border line을 보여주는 기능을 함
                                      // focusedBorder를 사용하지 않으면 텍스트를 입력할 때 Border가 사라짐.
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    // TextFormField의 사이즈를 바꿀 수 있음
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // 텍스트 폼 필드
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 420 : 380,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  // Center 위젯으로 감싸주지 않으면 Positioned의 right와 left가 각각 0이므로 최대한 공간을 많이 차지하게 되어 원이 깨진다.
                  padding: const EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      if (isSignupScreen) {
                        _tryValidation();
                        try {
                          final newUser = await _authentication
                              .createUserWithEmailAndPassword(
                                  email: userEmail, password: userPassword);
                          if (newUser.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ChatScreen();
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Please check your email and password'),
                            backgroundColor: Colors.blue,
                          ));
                        }
                      }
                      if (!isSignupScreen) {
                        _tryValidation();
                        try {
                          final newUser =
                              await _authentication.signInWithEmailAndPassword(
                                  email: userEmail, password: userPassword);
                          if (newUser.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ChatScreen();
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          // gradient는 몇가지 색상이 섞여서 나오므로 colors에는 list 형태의 값을 받는다.
                          colors: [
                            Colors.orange,
                            Colors.red,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          // gradient의 방향을 지정해준다.
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                            // offset이란 버튼 그림자가 버튼으로부터 가지는 거리를 나타낸다.
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 전송 버튼 필드
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen
                  ? MediaQuery.of(context).size.height - 140
                  : MediaQuery.of(context).size.height - 180,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(
                    isSignupScreen ? 'or Signup with' : 'or Signin with',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Palette.googleColor,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Google'),
                  ),
                ],
              ),
            ),
            // 구글 로그인 버튼
          ],
        ),
      ),
    );
  }
}
