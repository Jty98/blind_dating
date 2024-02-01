import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:blind_dating/view/signupfirst.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const Login({super.key, required this.onChangeTheme});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  late AppLifecycleState _lastLifeCycleState;
  late TextEditingController IDController;
  late TextEditingController PWController;
  late String inputValue;

  // 유저와 관련된 getX
  final LoadUserData userDataController = Get.put(LoadUserData());

  @override
  void initState() {
    super.initState();
    IDController = TextEditingController(text: UserModel.uid);
    // IDController = TextEditingController(text: '1');
    PWController = TextEditingController();
    inputValue = "";

    WidgetsBinding.instance.addObserver(this); // opserver 만들기
    // loadUserData();
    _initSharedPreferences();
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: IDController, // 글씨가 들어온줄 인식하는곳이 controller
                  decoration: const InputDecoration(
                    hintText: '아이디',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 88, 104, 126),
                    ), // 텍스트필드에 작게 가이드해주는 텍스트
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ), // textfield 테두리
                  ),
                  // readOnly: true, // keyboard타입 정해주기
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: PWController, // 글씨가 들어온줄 인식하는곳이 controller
                  decoration: const InputDecoration(
                    labelText: 'Password를 입력해주세요',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 88, 114, 126),
                    ), // 텍스트필드에 작게 가이드해주는 텍스트
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    // textfield 테두리
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    inputValue = PWController.text;
                  },
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  loginCheck();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    backgroundColor: Color.fromARGB(255, 141, 148, 244),
                    foregroundColor: Color.fromARGB(255, 245, 245, 245)),
                child: const Text(
                  "로그인",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => Get.to(() => SignUpFirst(onChangeTheme: widget.onChangeTheme)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    backgroundColor: Color.fromARGB(255, 141, 148, 244),
                    foregroundColor: Color.fromARGB(255, 245, 245, 245)),
                child: const Text(
                  "회원가입",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginCheck() async {
    try {
      var uid = IDController.text; // 사용자가 입력한 ID
      var upw = PWController.text; // 사용자가 입력한 ID
      var url = Uri.parse(
          'http://localhost:8080/Flutter/dateapp_user_logincheck_flutter.jsp?uid=$uid&upw=$upw');
      final resp = await http.get(url);

      String responseData = resp.body.trim(); // JSP 페이지로부터의 응답을 문자열로 받음

      print('responseData : ${responseData}');
      if (responseData == '1') {
        Get.to(() => HomeWidget(
              onChangeTheme: widget.onChangeTheme,
            ));
        _saveSharePreferencese(); // Get.to() 이후에 호출
      } else {
        Get.snackbar(
          "ERROR",
          "아이디나 비밀번호를 다시 확인해주세요.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 156, 161, 189),
        );
      }
    } catch (error) {
      print('Error occurred while checking UID: $error');
    }
  }

  // 초기 id, pw를 Textfiled에서 가져와서 key값 uid, vlaue값 idText.text으로 구성되게 해줌
  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    IDController.text = prefs.getString("uid") ?? "";
    PWController.text = prefs.getString("upw") ?? "";

    print("아이디 텍스트필드: ${IDController.text}");
    print("패스워드 텍스트필드: ${PWController.text}");
  }

  // 이 함수가 내 기기에 id정보를 저장시키는 것이고 Get.to로 넘겨주는 부분
  //_initSharedPreferences에서 설정한 key값 uid, upw를 넘김
  _saveSharePreferencese() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', IDController.text.trim());
    prefs.setString('upw', PWController.text.trim());
    UserModel.uid = IDController.text.trim();
    UserModel.upw = PWController.text.trim();
  }

  _disposeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
