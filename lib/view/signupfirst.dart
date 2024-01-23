import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/signupsecond.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class SignUpFirst extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpFirst({super.key, required this.onChangeTheme});

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  late TextEditingController IDController;
  late TextEditingController PWController;
  late TextEditingController PWCheckController;
  late TextEditingController AddressController;
  late TextEditingController NickNameController;
  late String inputValue;
  String selectedGender = "";

  @override
  void initState() {
    super.initState();
    IDController = TextEditingController(text: UserModel.uid);
    // IDController = TextEditingController(text: "01036488391");
    PWController = TextEditingController();
    PWCheckController = TextEditingController();
    AddressController = TextEditingController();
    NickNameController = TextEditingController();
    inputValue = "";
  }
  

  DateTime dateTime = DateTime(2000, 1, 1);

  void saveDataToUserModel() {
    UserModel.uid = IDController.text;
    UserModel.upw = PWController.text;
    UserModel.uaddress = AddressController.text;
    UserModel.unickname = NickNameController.text;
    UserModel.ugender = (selectedGender == "Male") ? '0' : '1';
    UserModel.ubirth =
        '${dateTime.year}-${dateTime.month}-${dateTime.day}'; // 저장된 생년월일 값

      print('id: ${UserModel.uid}');
      print('upw: ${UserModel.upw}');
      print('unickname: ${UserModel.unickname}');
      print('ugender: ${UserModel.ugender}');
      print('ubirth: ${UserModel.ubirth}');
      print('uaddress: ${UserModel.uaddress}');
    
  }


  void showSnackBar(String message) {
    Get.snackbar(
      "ERROR",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 232, 157, 157),
    );
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
                Image.asset('images/stepfirst.png'),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 16),
                    controller: IDController,
                    decoration: const InputDecoration(
                        hintText: '아이디',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 88, 104, 126),
                        )),
                    readOnly: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: TextField(
                      style: TextStyle(fontSize: 16),
                      controller: NickNameController,
                      decoration: const InputDecoration(
                          hintText: '닉네임',
                          prefixIcon: Icon(
                            Icons.person_add_alt_1,
                            color: Color.fromARGB(255, 88, 104, 126),
                          )),
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        inputValue = NickNameController.text;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: PWController,
                    decoration: const InputDecoration(
                        labelText: "비밀번호",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 88, 114, 126),
                        )),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      inputValue = PWController.text;
                    },
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: PWCheckController,
                    decoration: const InputDecoration(
                        labelText: "비밀번호 확인",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 88, 114, 126),
                        )),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      inputValue = PWCheckController.text;
                    },
                    obscureText: true,
                  ),
                ),
                Text(
                  '비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자로 입력해 주세요.',
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: TextField(
                      style: TextStyle(fontSize: 16),
                      controller: AddressController,
                      decoration: const InputDecoration(
                          hintText: '주소',
                          prefixIcon: Icon(
                            Icons.home,
                            color: Color.fromARGB(255, 88, 104, 126),
                          )),
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        inputValue = AddressController.text;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 110, 20),
                  child: Text(
                    "주소는 '광역시도-시군구'까지만 입력해 주세요.",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 30, 0),
                      child: Text(
                        '성별',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 54, 54, 58),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedGender = "Male";
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(120, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedGender == "Male"
                                ? Color.fromARGB(255, 255, 238, 150)
                                : Color.fromARGB(255, 239, 238, 238),
                            foregroundColor: Color.fromARGB(255, 80, 100, 144)),
                        icon: Icon(Icons.man),
                        label: Text(
                          'Male',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedGender = "Female";
                          });
                        },
                        style: TextButton.styleFrom(
                            minimumSize: Size(120, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedGender == "Female"
                                ? Color.fromARGB(255, 255, 238, 150)
                                : Color.fromARGB(255, 239, 238, 238),
                            foregroundColor: Color.fromARGB(255, 80, 100, 144)),
                        icon: Icon(Icons.woman),
                        label: Text(
                          'Female',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                      child: Text(
                        '생년월일',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 54, 54, 58),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CupertinoButton(
                      color: Color.fromARGB(255, 150, 170, 189),
                      child: Text(
                          '${dateTime.year}-${dateTime.month}-${dateTime.day}'),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                                  height: 550,
                                  child: CupertinoDatePicker(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    initialDateTime: dateTime,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() => dateTime = newTime);
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                  child: ElevatedButton(
                    onPressed: () {
                          if (IDController.text.isEmpty ||
                          PWController.text.isEmpty ||
                          PWCheckController.text.isEmpty ||
                          AddressController.text.isEmpty ||
                          NickNameController.text.isEmpty ||
                          selectedGender.isEmpty) {
                          Get.snackbar(
                          "ERROR",
                          "모든 항목을 입력해 주세요.",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                          backgroundColor: Color.fromARGB(255, 247, 228, 162),
                        );
                          }else if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).{8,15}$')
                            .hasMatch(PWController.text)) {
                              showSnackBar('비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자여야 합니다.');
                            } else if (PWController.text !=
                                PWCheckController.text) {
                              showSnackBar('비밀번호가 일치하지 않습니다.');
                              } else {
                              saveDataToUserModel();
                              Get.to(() => SignUpSecond(onChangeTheme: widget.onChangeTheme,));
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
                      "다음",
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
}
