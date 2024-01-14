import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blind_dating/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoadUserData extends GetxController {
  String uid = "";
  String upw = "";

  // Rx<Position?> currentPosition = Rx<Position?>(null);
  late Position currentPosition;
  var isPermissionGranted = false.obs;
  var userList = [].obs; // 유저 정보를 저장할 리스트
  RxInt userGrant = 0.obs;
  RxBool canRun = false.obs;
  RxDouble mylat = 0.0.obs;
  RxDouble mylng = 0.0.obs;

  @override
  void onInit() async {
    await getCurrentLocation();
    super.onInit();
  }

  grantStatus(value) {
    userGrant.value = value;
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
    // String nickname = "";
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? " ";
    uid = UserModel.uid;
    upw = prefs.getString('upw') ?? " ";
    upw = UserModel.upw;
    // nickname = UserModel.unickname;
    print("로그인된 아이디: $uid");
    print("로그인된 패스워드: $upw");
    // print("로그인된 nickname: $nickname");
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
    List result = [];
    // initSharedPreferences에서 uid만 가져와서 요청 보내기
    String getUid = await initSharedPreferences();
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_login_quary_flutter.jsp?uid=$getUid');
    try {
      var response = await http.get(url); // 데이터가 불러오기 전까지 화면을 구성하기 위해 기다려야됨
      loginData.clear(); // then해주면 계속 쌓일 수 있으니 클리어해주기
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['results'];
      loginData.addAll(result);
      // print("Login result: $result");
      return loginData;
    } catch (e) {
      print('error: $e');
    }
    return loginData;
    // print(url);
  }

  // ================== 로그인 관리 ==================
  // 전체 유저 불러오기
  Future<List> getUserData() async {
    List userData = [];
    String getUid = await initSharedPreferences();

    print("getUid: $getUid");
    print("1111");
    // updateLocation()로 로그인된 유저 업데이트가 끝나서 true를 반환하면 진행
    try {
      print(42312);
      // if (await updateLocation()) {
      var url = Uri.parse(
          // 'http://localhost:8080/Flutter/dateapp_quary_flutter.jsp?uid=$getUid');
          'http://localhost:8080/Flutter/dateapp_quary_flutter.jsp?uid=$getUid');
      var response = await http.get(url);
      print(response.statusCode);
      // print(response.body);
      userData.clear();
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      List result = dataConvertedJSON['results'];
      print(result);
      userData.addAll(result);
      return result;
      // } else {
      // updateLocation()이 실패한 경우
      // throw Exception("updateLocation() failed");
      // }
    } catch (e) {
      // 예외 처리 코드
      print(e);
      return Future.error(e);
    }
  }

  // ================== 위치 관리 ==================

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

// 구독 관리 (select 해봐서 만료일이 현재일을 지났으면 사용자 권한을 0으로 업데이트)
  Future<bool> userGrantUpdate() async {
    String getUid = await initSharedPreferences();

    var url = Uri.parse(
        "http://localhost:8080/Flutter/dateapp_ugrant_update_flutter.jsp?user_uid=$getUid");

    var response = await http.get(url);
    var dataConvertedJSON =
        json.decode(utf8.decode(response.bodyBytes)); // 딕셔너리로 바꾸는 과정
    var result = dataConvertedJSON['result']; // return 해주는게 result라는 키값이라서
    if (result == 'user unsubscribe') {
      print("기간이 만료됨에따라 구독 해제되었습니다.");
      return true;
    } else {
      print("아무일도 일어나지 않음");
      return false;
    }
  }

// 권한요청
  // Future<bool> _determinePermission() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   print(12301230212032103);
  //   if (!serviceEnabled) {
  //     print(12301230212032103);
  //     return false;
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return false;
  //   }
  //   return true;
  // }

  /// 내 위치 불러오기
  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((position) {
      currentPosition = position;
      canRun.value = true;
      mylat.value = currentPosition.latitude;
      mylng.value = currentPosition.longitude;
    }).catchError((e) {
      debugPrint("지도파트 오류(near_toilet_view.dart) : $e");
    });
  }

  /// 위치 사용 권한 확인
  checkLocationPermission() async {
    // permission 받을때 까지 await를 통해 대기해야함. 사용자의 선택에 따라 활동이 정해지거나 대기해야 하면 무조건 async await
    LocationPermission permission =
        await Geolocator.checkPermission(); // 사용자의 허용을 받았는지 여부에 따라 조건문 작성
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation(); // 허용하면 현재 위치 가져오는 함수 실행
    }
  }

  /// 두 지점 간의 거리 계산
  List<double> calculateDistances() {
    List<double> distances = [];

    if (currentPosition == null) {
      return distances; // 빈 리스트 반환
    } else {
      // 내 위도경도
      double myLatitude = currentPosition.latitude;
      double myLongitude = currentPosition.longitude;

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

      print("@@@ distances: $distances");
      return distances;
    }
  }

  //   // ================== 로그인한 유저 현재 위치 업데이트 ==================
  // Future<bool> updateLocation() async {
  //   String getUid = await initSharedPreferences();
  //   // if (currentPosition == null) {
  //   //   return false; // 위치가 없을 때 false 반환
  //   // } else {
  //     double myLatitude = currentPosition.latitude;
  //     double myLongitude = currentPosition.longitude;

  //     var url = Uri.parse(
  //         'http://localhost:8080/Flutter/dateapp_update_location_flutter.jsp?ulat=$myLatitude&ulng=$myLongitude&uid=$getUid');
  //     var response = await http.get(url);
  //     var dataConvertedJSON =
  //         json.decode(utf8.decode(response.bodyBytes)); // 딕셔너리로 바꾸는 과정
  //     var result = dataConvertedJSON['result']; // return 해주는게 result라는 키값이라서
  //     if (result == 'OK') {
  //       print("사용자 업데이트가 성공되었습니다.");
  //       return true;
  //     } else {
  //       print("사용자 업데이트가 실패하였습니다.");
  //       return false;
  //     }
  //   // }
  // }

// // GPS 정보 얻기
//   Future<Position?> _getPosition() async {
//     print("object");
//     try {
//       LocationPermission permission =
//           await Geolocator.requestPermission(); // 위치 권한 permission 띄우기
//       print("object1");
//       if (permission == LocationPermission.denied) {
//         // 위치 권한이 거부되었을 때
//         _showPermissionDeniedDialog(); // 다이어로그 표시
//         return null;
//       } else {
//         // Position position = await Geolocator.getCurrentPosition(
//         //     desiredAccuracy:
//         //         LocationAccuracy.best); // 내 위치를 가져오는 실질적인 부분으로 best한 위치를 가져옴
//         // print("position: $position");

//         // return position;
//             await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//       forceAndroidLocationManager: true).then((position) {
//         currentPosition = position;
//         canRun.value = true;
//         mylat.value = currentPosition.latitude;
//         mylng.value = currentPosition.longitude;
//         print(mylat.value);
//         print(mylng.value);
//       }).catchError((e){
//         debugPrint("지도파트 오류(near_toilet_view.dart) : $e");
//       });

//       }
//     } catch (e) {
//       if (e is PermissionRequestInProgressException) {
//         // 위치 권한 요청이 이미 진행 중임
//         return Future.error("권한 요청이 이미 진행중입니다.");
//       }
//       // 위치 권한이 거부됨
//       _showPermissionDeniedDialog();
//       return null;
//     }
//   }
  // ================== 위치 관리 ==================
} // // ================== End ==================
