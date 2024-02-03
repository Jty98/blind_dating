import 'dart:io';
import 'package:blind_dating/components/ai_result_chart.dart';
import 'package:blind_dating/view/signupthird.dart';
import 'package:blind_dating/viewmodel/signup_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// final Uri uri = Uri.parse('http://ec2-52-78-36-96.ap-northeast-2.compute.amazonaws.com:5000/upload');

class SignUpSecond extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpSecond({Key? key, required this.onChangeTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final signUpController = Get.find<SignUpController>();
    final SignUpController signUpController = Get.put(SignUpController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '닮은 견종 테스트',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(94, 88, 176, 0.945),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('images/stepsecond.png'),
              const SizedBox(height: 55),
              galleryAreaWidget(signUpController: signUpController),
              const SizedBox(height: 25),
              galleryButtonWidget(
                  context: context, signUpController: signUpController),
              Obx(
                () => signUpController.resultBreedImg.value.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Image.asset(
                                signUpController.resultBreedImg.value,
                                width: 100,
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  '당신은 ${signUpController.resultPercent.value.toStringAsFixed(0)}% 확률로',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "'${signUpController.dogTypeResult.value}'를 닮았습니다!",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 80),
                child: ElevatedButton(
                  onPressed: () {
                    signUpController.resultMapList.isEmpty
                        ? showErrorDialog(context, '테스트를 진행하지 않았습니다.')
                        : Get.to(() => SignUpThird(
                              onChangeTheme: onChangeTheme,
                            ));
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
                      color: Color.fromARGB(255, 234, 234, 236),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 결과를 띄우는 다이얼로그
  resultDialog(SignUpController signUpController) {
    return Get.dialog(
      Dialog(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AIResultChart(signUpController: signUpController),
              CupertinoButton.filled(
                child: const Text("확인"),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 이미지 띄우는 공간의 위젯
  Widget galleryAreaWidget({required SignUpController signUpController}) {
    return Obx(
      () => Stack(
        children: [
          signUpController.galleryImage.value != null
              ? Container(
                  width: 300,
                  height: 300,
                  color: const Color.fromARGB(255, 212, 221, 247),
                  child: Image.file(
                      File(signUpController.galleryImage.value!.path)),
                )
              : Container(
                  width: 300,
                  height: 300,
                  color: const Color.fromARGB(255, 212, 221, 247),
                ),
          if (signUpController.galleryImage.value != null)
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  signUpController.resetData();
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 갤러리 버튼 누를시 함수
  Widget galleryButtonWidget(
      {required BuildContext context,
      required SignUpController signUpController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            signUpController.resetData();
            signUpController.getImage(ImageSource.gallery);
          },
          style: TextButton.styleFrom(
              minimumSize: const Size(130, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromARGB(255, 146, 148, 255),
              foregroundColor: const Color.fromARGB(255, 234, 234, 236)),
          icon: const Icon(Icons.photo),
          label: const Text(
            "갤러리",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 20), // 간격을 위해 추가한 코드
        ElevatedButton.icon(
            onPressed: () async {
              // if (signUpController.galleryImage.value == null) {
              if (signUpController.galleryImage.value == null) {
                showErrorDialog(context, '사진을 선택해주세요');
              }

              try {
                await signUpController.uploadImage(signUpController
                    .galleryImage.value); // 결과를 dogTypeResult에 저장

                resultDialog(signUpController);

                // signUpController.hasReceivedResult = true;
              } catch (e) {
                debugPrint("Error: $e");
              }
            },
            style: TextButton.styleFrom(
                minimumSize: const Size(130, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(255, 146, 148, 255),
                foregroundColor: const Color.fromARGB(255, 234, 234, 236)),
            icon: const Icon(Icons.pets),
            label: const Text(
              "닮은 강아지 찾기",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  /// 사진 선택 안했을 때 띄우는 다이얼로그
  showErrorDialog(BuildContext context, String text) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // 다른곳 클릭시 닫기
      builder: (BuildContext context) {
        return errorDialog(text);
      },
    );
  }

  CupertinoAlertDialog errorDialog(String text) {
    return CupertinoAlertDialog(
      title: const Text("실패"),
      content: Text(text),
      actions: [
        CupertinoDialogAction(
          child: CupertinoButton(
            child: const Text("확인"),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}

// End
