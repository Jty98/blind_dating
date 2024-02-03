import 'dart:convert';

import 'package:blind_dating/model/ai_result_model.dart';
import 'package:blind_dating/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  late TextEditingController iDController;
  late TextEditingController pWController;
  late TextEditingController pWCheckController;
  late TextEditingController addressController;
  late TextEditingController nickNameController;
  late String inputValue;
  RxString selectedGender = "".obs;
  RxString dateTime = '2000-01-01'.obs;

  // XFile? photoImage;
  Rx<XFile?> photoImage = Rx<XFile?>(null);
  Rx<XFile?> galleryImage = Rx<XFile?>(null);
  // bool hasReceivedResult = false; //모델결과값 받아오기 전까지는 다음버튼 비활성화
  // bool isButtonPressed = false; // 버튼이 눌렸는지 여부
  final ImagePicker picker = ImagePicker();
  RxString dogTypeResult = "".obs; // 강아지 종류를 저장하는 변수
  RxDouble resultPercent = 0.0.obs; // 강아지 결과 퍼센트
  RxString resultBreedImg = "".obs; // 강아지 결과 이미지
  List<String> resultBreedList = [
    '말티즈',
    '불테리어',
    '비숑프리제',
    '사모예드',
    '시바이누',
    '진돗개',
    '포메라니안',
    '허스키'
  ];

  List<AIResultModel> resultMapList = [];
  TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void onInit() {
    super.onInit();
    iDController = TextEditingController(text: UserModel.uid);
    pWController = TextEditingController();
    pWCheckController = TextEditingController();
    addressController = TextEditingController();
    nickNameController = TextEditingController();
    inputValue = "";
  }

  /// 선택된 유저 정보 저장하는 함수
  void saveDataToUserModel() {
    UserModel.uid = iDController.text;
    UserModel.upw = pWController.text;
    UserModel.uaddress = pWCheckController.text;
    UserModel.unickname = nickNameController.text;
    UserModel.ugender = (selectedGender.value == "Male") ? '0' : '1';
    UserModel.ubirth =
        '${DateTime.parse(dateTime.value).year}-${DateTime.parse(dateTime.value).month}-${DateTime.parse(dateTime.value).day}'; // 저장된 생년월일 값

    print('id: ${UserModel.uid}');
    print('upw: ${UserModel.upw}');
    print('unickname: ${UserModel.unickname}');
    print('ugender: ${UserModel.ugender}');
    print('ubirth: ${UserModel.ubirth}');
    print('uaddress: ${UserModel.uaddress}');
  }

  /// 이미지 올려서 AI 모델 돌리는 함수
  uploadImage(XFile? imageFile) async {
    resultMapList.clear();
    if (imageFile == null) {
      throw Exception('No image provided');
    }

    final Uri uri = Uri.parse('http://127.0.0.1:5000/predict');

    // POST 메서드를 사용하도록 수정
    final http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final List<dynamic> responseBody =
            json.decode(await response.stream.bytesToString());
        List<Map<String, dynamic>> resultList = List.from(responseBody);
        // 처리된 JSON 결과 사용
        resultMapList.addAll(
            resultList.map((data) => AIResultModel.fromMap(data)).toList());

        dogTypeResult.value = resultMapList[0].breed;
        resultPercent.value = resultMapList[0].probability;
        showResultImg(resultMapList[0].breed);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to upload image');
    }
    return null;
  }

  /// 견종 결과 이미지를 설정하는 함수
  showResultImg(String resultBreed) {
    // images/사모예드.png
    for (String result in resultBreedList) {
      if (resultBreed == result) {
        resultBreedImg.value = 'images/$result.png';
        break;
      }
    }
  }

  /// 이미지 픽커 열기 함수
  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      if (imageSource == ImageSource.camera) {
        photoImage.value = pickedFile;
      } else {
        galleryImage.value = pickedFile;
      }
    }
  }

  /// AI결과 데이터 초기화시키는 함수
  resetData() {
    resultBreedImg.value = ''; // 결과를 초기화
    resultMapList.clear(); // 결과를 초기화
    galleryImage.value = null;
  }

  @override
  void dispose() {
    super.dispose();
    iDController.dispose();
    pWController.dispose();
    pWCheckController.dispose();
    addressController.dispose();
    nickNameController.dispose();
  }
}
