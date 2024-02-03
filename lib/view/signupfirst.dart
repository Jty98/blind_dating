import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/signupsecond.dart';
import 'package:blind_dating/viewmodel/signup_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class SignUpFirst extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpFirst({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(94, 88, 176, 0.945),
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
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
                const SizedBox(
                  height: 15,
                ),
                showTextField(
                  signUpController: signUpController,
                  textController: signUpController.iDController,
                  getIcon: Icons.person,
                  hintText: '아이디',
                  passwordKey: false,
                ),
                showTextField(
                  signUpController: signUpController,
                  textController: signUpController.pWController,
                  getIcon: Icons.lock,
                  hintText: '비밀번호',
                  passwordKey: true,
                ),
                showTextField(
                  signUpController: signUpController,
                  textController: signUpController.pWCheckController,
                  getIcon: Icons.lock,
                  hintText: '비밀번호 확인',
                  passwordKey: true,
                ),
                const Text(
                  '비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자로 입력해 주세요.',
                  style: TextStyle(fontSize: 12),
                ),
                showTextField(
                  signUpController: signUpController,
                  textController: signUpController.nickNameController,
                  getIcon: Icons.person_add_alt_1,
                  hintText: '닉네임',
                  passwordKey: false,
                ),
                showTextField(
                  signUpController: signUpController,
                  textController: signUpController.addressController,
                  getIcon: Icons.home,
                  hintText: '주소',
                  passwordKey: true,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 110, 20),
                  child: Text(
                    "주소는 '광역시도-시군구'까지만 입력해 주세요.",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 30, 0),
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
                            signUpController.selectedGender.value = "Male";
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: signUpController
                                          .selectedGender.value ==
                                      "Male"
                                  ? const Color.fromARGB(255, 255, 238, 150)
                                  : const Color.fromARGB(255, 239, 238, 238),
                              foregroundColor:
                                  const Color.fromARGB(255, 80, 100, 144)),
                          icon: const Icon(Icons.man),
                          label: const Text(
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
                            signUpController.selectedGender.value = "Female";
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: signUpController
                                          .selectedGender.value ==
                                      "Female"
                                  ? const Color.fromARGB(255, 255, 238, 150)
                                  : const Color.fromARGB(255, 239, 238, 238),
                              foregroundColor:
                                  const Color.fromARGB(255, 80, 100, 144)),
                          icon: const Icon(Icons.woman),
                          label: const Text(
                            'Female',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(18, 0, 15, 0),
                      child: Text(
                        '생년월일',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 54, 54, 58),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Obx( ()
                    //   =>
                    CupertinoButton(
                      color: const Color.fromARGB(255, 150, 170, 189),
                      child: Obx(
                        () => Text(
                            '${DateTime.parse(signUpController.dateTime.value).year}-${DateTime.parse(signUpController.dateTime.value).month}-${DateTime.parse(signUpController.dateTime.value).day}'),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                                  height: 550,
                                  child: CupertinoDatePicker(
                                    
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    initialDateTime: DateTime.parse(
                                        signUpController.dateTime.value),
                                    onDateTimeChanged: (DateTime newTime) {
                                      signUpController.dateTime.value =
                                          newTime.toString();
                                    },
                                    
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ));
                      },
                    ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                  child: ElevatedButton(
                    onPressed: () {
                      checkLogin(signUpController: signUpController);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50),
                      backgroundColor: const Color.fromARGB(255, 146, 148, 255),
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
  // --- Functions ---

  /// 회원가입 조건 미충족시 나오는 스낵바
  showSnackBar(String message) {
    Get.snackbar(
      "ERROR",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 232, 157, 157),
    );
  }

  /// 회원가입 유효성 체크하는 함수
  checkLogin({required SignUpController signUpController}) {
    if (signUpController.iDController.text.isEmpty ||
        signUpController.pWController.text.isEmpty ||
        signUpController.pWCheckController.text.isEmpty ||
        signUpController.addressController.text.isEmpty ||
        signUpController.nickNameController.text.isEmpty ||
        signUpController.selectedGender.isEmpty) {
      Get.snackbar(
        "ERROR",
        "모든 항목을 입력해 주세요.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 247, 228, 162),
      );
    } else if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).{8,15}$')
        .hasMatch(signUpController.pWController.text)) {
      showSnackBar('비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자여야 합니다.');
    } else if (signUpController.pWController.text !=
        signUpController.pWCheckController.text) {
      showSnackBar('비밀번호가 일치하지 않습니다.');
    } else {
      signUpController.saveDataToUserModel();
      Get.to(() => SignUpSecond(
            onChangeTheme: onChangeTheme,
          ));
    }
  }

  /// 중복되는 텍스트필드 위젯
  showTextField({
    required SignUpController signUpController,
    required TextEditingController textController,
    required IconData getIcon,
    required String hintText,
    required bool passwordKey,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: const TextStyle(fontSize: 16),
        controller: textController,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              getIcon,
              color: const Color.fromARGB(255, 88, 104, 126),
            )),
        // readOnly: true,
        // keyboardType: TextInputType.text,
        onSubmitted: (value) {
          signUpController.inputValue = textController.text;
        },
        obscureText: passwordKey,
      ),
    );
  }
} // End
