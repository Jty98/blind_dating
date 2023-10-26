import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoadUserData extends GetxController {
  String uid = "";
  String upw = "";

  Rx<Position?> myLocation = Rx<Position?>(null);
  var isPermissionGranted = false.obs;
  var userList = [].obs; // 유저 정보를 저장할 리스트
  

  // 두 지점 간의 거리 계산
  List<double> calculateDistances() {
    List<double> distances = [];

    if (myLocation.value == null) {
      return distances; // 빈 리스트 반환
    } else {
      // 내 위도경도
      double myLatitude = myLocation.value!.latitude;
      double myLongitude = myLocation.value!.longitude;

      // 사용자 2명의 위도경도
      for (int i = 0; i < userList.length; i++) {
        double userLatitude = userList[i]['ulat'];
        double userLongitude = userList[i]['ulng'];

        // 위도 경도간의 직선거리
        double distanceInMeters = Geolocator.distanceBetween(
          myLatitude,
          myLongitude,
          userLatitude,
          userLongitude,
        );
        // 거리를 리스트에 추가
        distances.add(distanceInMeters); 
      }

      return distances;
    }
  }

  // 받아온 생년월일을 가지고 만나이 계산
  ageCalc() {
    List<int> userAge = []; // 나이를 저장하는 리스트
    for (int i = 0; i < userList.length; i++) {
      DateTime birthDate = DateTime.parse(userList[i]['ubirth']);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }
      userAge.add(age); // 나이를 리스트에 추가
      // print("getXuserAge: $userAge");
    }
    return userAge;
  }

  // ================== 로그인 관리 ==================
  // 로그인된 유저의 uid 들고가기
  Future<String> initSharedPreferences() async {
    String uid = "";
    String upw = "";
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? " ";
    upw = prefs.getString('upw') ?? " ";
    print("로그인된 아이디: $uid");
    print("로그인된 패스워드: $upw");
    return uid;
  }

  // 로그인된 유저 정보 들고오기
  /*
  조회하는 기준은 로그인된 유저와 반대 성별 중에서 유저의 uaddress의 시까지 조회해서 그중에서 일치하는사람 2명 랜덤 조회
  2명이 카운트가 안될시 전국으로 조회
  구까지 할려고 했으나 지역명에 구가 안들어가는 지역도 있고 시가 제일 조회하기 편함
  */
  Future<List> getLoginData() async {
    List loginData = [];
    // initSharedPreferences에서 uid만 가져와서 요청 보내기
    String getUid = await initSharedPreferences();
    // print("getLoginData uid:$getUid");
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_login_quary_flutter.jsp?uid=$getUid');
    // print(url);
    var response = await http.get(url); // 데이터가 불러오기 전까지 화면을 구성하기 위해 기다려야됨
    loginData.clear(); // then해주면 계속 쌓일 수 있으니 클리어해주기
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    loginData.addAll(result);
    // print("Login result: $result");
    return result;
  }
  // ================== 로그인 관리 ==================

  // 전체 유저 불러오기
  Future<List> getUserData() async {
    List userData = [];
    // initSharedPreferences에서 uid만 가져와서 요청 보내기
    String getUid = await initSharedPreferences();
    // print("getLoginData uid:$getUid");
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_quary_flutter.jsp?uid=$getUid');
    var response = await http.get(url); // 데이터가 불러오기 전까지 화면을 구성하기 위해 기다려야됨
    userData.clear(); // then해주면 계속 쌓일 수 있으니 클리어해주기
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    userData.addAll(result);
    print("result: $result");
    return result;
  }

  // ================== 위치 관리 ==================
  // 앱 처음 위치 가져오기
  Future<Position?> initLocation() async {
    final permissionGranted = await _determinePermission();
    if (permissionGranted) {
      final position = await _getPosition();
      if (position != null) {
        // print("get Position: $position");
        myLocation.value = position;
      } else {
        // 위치 정보를 가져오지 못한 경우에 대한 처리
        // print('못 가저오면 어쩔건데');
      }
    } else {
      // 위치 권한이 거부된 경우에 대한 처리
      // _showPermissionDeniedDialog();
    }
    return await _getPosition();
  }

// 위치 권한 거부 시 다이어로그 표시
  void _showPermissionDeniedDialog() {
    Get.defaultDialog(
      title: '권한 거부됨',
      middleText: '앱 사용을 위해 위치 권한이 필요합니다.\n 권한을 허용하지 않을 시 서비스를 이용할 수 없습니다.',
      barrierDismissible: false,
      actions: [
        // TextButton(
        //   onPressed: () async {
        //     // 권한을 허용하는 부분 추가
        //     final permissionGranted = await locationController.requestLocationPermission();
        //     if (permissionGranted) {
        //       // 권한이 허용되었을 때 추가 동작 수행
        //       final position = await _getPosition();
        //       if (position != null) {
        //         print(position);
        //       }
        //     }
        //   },
        //   child: const Text('권한 허용'),
        // ),
        TextButton(
          onPressed: () {
            // 앱 종료 코드
            if (Platform.isIOS) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          },
          child: const Text('앱 종료'),
        ),
      ],
    );
  }

// 권한요청
  Future<bool> _determinePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

// GPS 정보 얻기
  Future<Position?> _getPosition() async {
    try {
      LocationPermission permission =
          await Geolocator.requestPermission(); // 위치 권한 permission 띄우기
      if (permission == LocationPermission.denied) {
        // 위치 권한이 거부되었을 때
        _showPermissionDeniedDialog(); // 다이어로그 표시
        return null;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy:
              LocationAccuracy.best); // 내 위치를 가져오는 실질적인 부분으로 best한 위치를 가져옴
      return position;
    } catch (e) {
      if (e is PermissionRequestInProgressException) {
        // 위치 권한 요청이 이미 진행 중임
        return Future.error("권한 요청이 이미 진행중입니다.");
      }
      // 위치 권한이 거부됨
      _showPermissionDeniedDialog();
      return null;
    }
  }
  // ================== 위치 관리 ==================
} // // ================== End ==================
