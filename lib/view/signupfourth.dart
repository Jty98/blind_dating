import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../homewidget.dart';

class SignUpFourth extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpFourth({super.key, required this.onChangeTheme});

  @override
  State<SignUpFourth> createState() => _SignUpFourthState();
}

class _SignUpFourthState extends State<SignUpFourth> {
  late String inputValue;
  String selectedSmoke = "";
  String selectedExtroverted = "";
  String selectedSensing = "";
  String selectedThinking = "";
  String selectedJudging = "";
  List<String> mbtiValues = []; // 선택된 MBTI 버튼 값을 저장할 리스트

  void saveDataToUserSecondModel() {
    UserModel.usmoke = (selectedSmoke == "흡연") ? '1' : '0';
    UserModel.umbti = (selectedExtroverted +
        selectedSensing +
        selectedThinking +
        selectedJudging);

        print('usmoke: ${UserModel.usmoke}');
        print('umbti: ${UserModel.umbti}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(94, 88, 176, 0.945),
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Get 패키지를 사용하여 이전 페이지로 이동합니다.
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('images/stepfourth.png'),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 10, 0),
                      child: Text(
                        '흡연여부',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 54, 54, 58),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSmoke = "흡연";
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(120, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedSmoke == "흡연"
                                ? Color.fromARGB(255, 250, 188, 152)
                                : Color.fromARGB(255, 239, 238, 238),
                            // backgroundColor: const Color.fromARGB(255, 238, 236, 236),
                            foregroundColor: Colors.black),
                        child: Text(
                          '흡연',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSmoke = "비흡연";
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(120, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedSmoke == "비흡연"
                                ? Color.fromARGB(255, 250, 188, 152)
                                : Color.fromARGB(255, 239, 238, 238),
                            foregroundColor: Colors.black),
                        child: Text(
                          '비흡연',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 330, 0),
                  child: Text(
                    'mbti',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 54, 54, 58),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 290, 0),
                  child: Text(
                    '외향형/내향형',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 54, 54, 58)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedExtroverted = "E";
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedExtroverted == "E"
                                ? Color.fromARGB(255, 254, 145, 145)
                                : Color.fromARGB(255, 239, 238, 238),
                            foregroundColor: Colors.black),
                        child: Text('E'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedExtroverted = 'I';
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedExtroverted == "I"
                                ? Color.fromARGB(255, 254, 145, 145)
                                : Color.fromARGB(255, 239, 238, 238),
                            foregroundColor: Colors.black),
                        child: Text('I'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 290, 0),
                  child: Text(
                    '감각형/직관형',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 54, 54, 58)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedSensing = 'S';
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedSensing == 'S'
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('S')),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedSensing = 'N';
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedSensing == 'N'
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('N')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 290, 0),
                  child: Text(
                    '사고형/감정형',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 54, 54, 58)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedThinking = 'T';
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedThinking == 'T'
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('T')),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedThinking = "F";
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedThinking == 'F'
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('F')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 290, 0),
                  child: Text(
                    '판단형/인식형',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 54, 54, 58)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedJudging = "J";
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedJudging == 'J'
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('J')),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedJudging = "P";
                            });
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(170, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: selectedJudging == "P"
                                  ? Color.fromARGB(255, 254, 145, 145)
                                  : Color.fromARGB(255, 239, 238, 238),
                              foregroundColor: Colors.black),
                          child: Text('P')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedSmoke.isEmpty ||
                          selectedExtroverted.isEmpty ||
                          selectedSensing.isEmpty ||
                          selectedThinking.isEmpty ||
                          selectedJudging.isEmpty) {
                        // 값이 비어있을 때 SnackBar 표시
                        Get.snackbar(
                          "ERROR",
                          "모든 항목을 선택해 주세요.",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                          backgroundColor: Color.fromARGB(255, 247, 228, 162),
                        );
                      } else {
                        await insertAction();
                        // Get.to(Login());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 50),
                      backgroundColor: Color.fromARGB(255, 146, 148, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "회원가입 완료",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 234, 234, 236)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //----------Functions
  insertAction() async {

    print('요청 url:http://localhost:8080/Flutter/dateapp_user_insert_flutter.jsp?uid=${UserModel.uid}&upw=${UserModel.upw}&unickname=${UserModel.unickname}&uhobbyimg1=${UserModel.uhobbyimg1}&uhobbyimg2=${UserModel.uhobbyimg2}&uhobbyimg3=${UserModel.uhobbyimg3}&ufaceimg1=${UserModel.ufaceimg1}&ufaceimg2=${UserModel.ufaceimg2}&ugender=${UserModel.ugender}&ubirth=${UserModel.ubirth}&uaddress=${UserModel.uaddress}&umbti=${UserModel.umbti}&usmoke=${UserModel.usmoke}&udogimg=${UserModel.udogimg}&ubreed=${UserModel.ubreed}');
    saveDataToUserSecondModel();
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_user_insert_flutter.jsp?uid=${UserModel.uid}&upw=${UserModel.upw}&unickname=${UserModel.unickname}&uhobbyimg1=${UserModel.uhobbyimg1}&uhobbyimg2=${UserModel.uhobbyimg2}&uhobbyimg3=${UserModel.uhobbyimg3}&ufaceimg1=${UserModel.ufaceimg1}&ufaceimg2=${UserModel.ufaceimg2}&ugender=${UserModel.ugender}&ubirth=${UserModel.ubirth}&uaddress=${UserModel.uaddress}&umbti=${UserModel.umbti}&usmoke=${UserModel.usmoke}&udogimg=${UserModel.udogimg}&ubreed=${UserModel.ubreed}');
    var response = await http.get(url);

      // 응답 확인 및 출력
    if (response.statusCode == 200) {
      // HTTP 요청이 성공하면 응답을 출력합니다.
      print('HTTP 요청 성공: ${response.body}');
      // 여기서 response.body는 서버로부터 받은 데이터입니다.
    } else {
      // HTTP 요청이 실패한 경우 에러를 출력합니다.
      print('HTTP 요청 실패: ${response.statusCode}');
    }
    showDialog();
  }

  showDialog() {
    Get.defaultDialog(
        title: '회원가입 완료',
        middleText: '회원가입이 완료되었습니다.',
        backgroundColor: Color.fromARGB(255, 247, 228, 162),
        barrierDismissible: false,
        actions: [
          TextButton(
              onPressed: () {
                // 모든 값이 선택되었을 때 홈 화면으로 이동
                Get.to(Login(onChangeTheme: widget.onChangeTheme,));
              },
              child: Text('닫기',style: TextStyle(color: Colors.black, fontSize: 13),))
        ]);
  }
}
