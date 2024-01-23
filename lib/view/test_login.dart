import 'dart:convert';

import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/mainpage.dart';
import 'package:blind_dating/view/signupfirst.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TestLogin extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const TestLogin({super.key, required this.onChangeTheme});

  @override
  State<TestLogin> createState() => _TestLoginState();
}

// 여기서 with WidgetsBindingObserver 추가해줘야됨
class _TestLoginState extends State<TestLogin> with WidgetsBindingObserver {
  late AppLifecycleState _lastLifeCycleState;
  late TextEditingController idText;
  late TextEditingController pwText;
  // 유저와 관련된 getX
  final LoadUserData userDataController = Get.put(LoadUserData());

  // 유저 정보 JSON으로 받아올 리스트
  // List data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this); // opserver 만들기
    idText = TextEditingController();
    pwText = TextEditingController();
    // loadUserData();
    _initSharedPreferences(); // SharedPreference 초기화
  }

  @override
  void dispose() {
    _disposeSharedPreferences();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached: // 떨어졌다
        print('detached');
        break;
      case AppLifecycleState.resumed: // 뒤에 숨어있다 나옴
        print("resumed");
        break;
      case AppLifecycleState.inactive: // 죽었다
        print('inactivive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    _lastLifeCycleState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idText, // 글씨가 들어온줄 인식하는곳이 controller
              decoration: const InputDecoration(
                labelText: '전화번호 형식의 ID를 입력해주세요', // 텍스트필드에 작게 가이드해주는 텍스트
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ), // textfield 테두리
              ),
              keyboardType: TextInputType.number, // keyboard타입 정해주기
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: pwText, // 글씨가 들어온줄 인식하는곳이 controller
              decoration: const InputDecoration(
                labelText: 'Password를 입력해주세요', // 텍스트필드에 작게 가이드해주는 텍스트
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ), // textfield 테두리
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                saveSharePreferencese();
                Get.to(() => HomeWidget(onChangeTheme: widget.onChangeTheme),); // 페이지로 저장시킬 id정보 넘기기
              },
              child: const Text('로그인'),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => SignUpFirst(onChangeTheme: widget.onChangeTheme,));
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  // 초기 id, pw를 Textfiled에서 가져와서 key값 uid, vlaue값 idText.text으로 구성되게 해줌
  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    idText.text = prefs.getString("uid") ?? "";
    pwText.text = prefs.getString("upw") ?? "";

    print("아이디 텍스트필드: ${idText.text}");
    print("패스워드 텍스트필드: ${pwText.text}");
  }

  // 이 함수가 내 기기에 id정보를 저장시키는 것이고 Get.to로 넘겨주는 부분
  //_initSharedPreferences에서 설정한 key값 uid, upw를 넘김
  saveSharePreferencese() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('uid', idText.text.trim());
    prefs.setString('upw', pwText.text.trim());
    UserModel.uid = idText.text.trim();
    UserModel.upw = pwText.text.trim();
  }

  _disposeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //   Future<List> loadUserData() async {
  //   var url = Uri.parse(
  //       'http://localhost:8080/Flutter/dateapp_login_quary_flutter.jsp?uid=${idText.text}');
  //   var response = await http.get(url); // 데이터가 불러오기 전까지 화면을 구성하기 위해 기다려야됨
  //   data.clear(); // then해주면 계속 쌓일 수 있으니 클리어해주기
  //   var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
  //   List result = dataConvertedJSON['results'];
  //   data.addAll(result);
  //   // print(result);
  //   print(result);
  //   return result;
  // }
}
