import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PayMentsController extends GetxController {
  RxBool checkAll = false.obs; // 모두 선택
  RxBool electronicPay = false.obs; // 전자거래 동의
  RxBool userInfoUsage = false.obs; // 개인정보 처리동의
  RxBool userInfoThirdParties = false.obs; // 3자 정보제공동의
  RxString selectedPayment = RxString(""); // 결제수단 종류
  String uid = "";
  String upw = "";


  // 결제수단 상태관리
  void funcSelectPayment(String value) {
    selectedPayment.value = value;
  }

  void funcAllCheck(bool value) {
    checkAll.value = value;
    electronicPay.value = value;
    userInfoUsage.value = value;
    userInfoThirdParties.value = value;
  }

  void funcElectroCheck(bool? value) {
    // if (value != null) {
    // 널체크 안해주면 얘는 고장남;
    electronicPay.value = value!;
    updateCheckAll();
    // }
  }

  void funcUserInfoCheck(bool value) {
    userInfoUsage.value = value;
    updateCheckAll();
  }

  void funcUserInfoThirdPartiesCheck(bool value) {
    userInfoThirdParties.value = value;
    updateCheckAll();
  }

  void updateCheckAll() {
    checkAll.value = electronicPay.value &&
        userInfoUsage.value &&
        userInfoThirdParties.value;
    // update();
  }

  Future<String> initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? " ";
    upw = prefs.getString('upw') ?? " ";
    print("pay send uid: $uid");
    print("pay send upw: $upw");
    return uid;
  }

  Future<List> getLoginData() async {
    List loginData = [];
    // initSharedPreferences에서 uid만 가져와서 요청 보내기
    String getUid = await initSharedPreferences();
    // print("getLoginData uid:$getUid");
    print('유저아이디는');
    // print(uid);
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_login_quary_flutter.jsp?uid=${getUid}');
    // print(url);
    var response = await http.get(url); // 데이터가 불러오기 전까지 화면을 구성하기 위해 기다려야됨
    loginData.clear(); // then해주면 계속 쌓일 수 있으니 클리어해주기
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    loginData.addAll(result);
    // print("Login result: $result");
    return result;
  }

  /// 결제 진행 및 결제 정보 저장
  Future<bool> purchaseAction(int pcode) async {
    String uid = await initSharedPreferences();
    try {
      var url = Uri.parse(
          "http://localhost:8080/Flutter/dateapp_purchase_flutter.jsp?user_uid=$uid&product_pcode=$pcode&payinformation=${selectedPayment.value}");
      await http.get(url);
      // await loadUserDataController.getUserData();
      await getLoginData();
      return true;
    } catch (e) {
      // 예외가 발생한 경우에 대한 처리
      print("오류 발생: $e");
      return false;
    }
  }
}
