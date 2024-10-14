// ignore_for_file: avoid_print, must_be_immutable

import 'package:blind_dating/components/main_imageSlider_widget.dart';
import 'package:blind_dating/model/sliderItems_model.dart';
import 'package:blind_dating/view/mainpage_detail.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:blind_dating/viewmodel/indicatorCurrent_crtl.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  MainPage({super.key, required this.onChangeTheme});
  // 앱 전역에서 사용자에게 채팅 요청 및 응답 다이어로그 보여주는 컨트롤러
  // final chatRequestController = Get.put(ChatRequest());

  // 이미지 슬라이더를 제어하기 위한 기본적인 컨트롤러
  final CarouselController sliderController = CarouselController();
  // 현재 이미지 슬라이더의 상태를 관리하는 GetX 컨트롤러
  final IndicatorCurrent indicatorCurrent = Get.put(IndicatorCurrent());
  // 유저와 관련된 getX
  final userDataController = Get.find<LoadUserData>();
  // 유저 거리를 담아놓을 변수
  String reciveUserDistance = "";
  // 유저 정보 JSON으로 받아올 리스트
  List userData = [];
  // 로그인된 유저 받아올 리스트
  List loginData = [];
  // 유저의 계산된 나이를 담을 리스트
  List userAge = [];
  // 유저 id
  String uid = "";
  // 유저 password
  String upw = "";
  // 권한에 따라 다른 이미지를 담기위한 변수
  String userImagepath1 = "";
  String userImagepath2 = "";
  String userImagepath3 = "";

  /*
  saveSharedPreferences로 저장된 로그인 정보 받기
  Future<String> initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? " ";
    upw = prefs.getString('upw') ?? " ";
    print("send uid: $uid");
    print("send upw: $upw");
    return uid;
  }
  */

  @override
  Widget build(BuildContext context) {
    /*
    유저와의 거리가 계산되는 순서 및 방식
    1. 앱 실행시 stateless라서 FutureBuilder를 써서 _initLocation() 함수를 쓰고 거기서 위치 권한 사용동의 창을 띄움
    2. 동의시에는 내 위치를 geolocator 패키지의 position이라는 변수에 저장됨 ex): Latitude: 37.49474, Longitude: 127.030034 이런식이라서 position.Latitude 하면 사용됨
    3. 그 다음 FutureBuilder에서는 _getPosition()이 내 위치를 가져오면 getXmodel부분의 myLocation변수에 position(내 위치)을 저장시킴
    4. 저장된 position값으로 calculateDistance()를 불러와서 계산하고 그걸 calcDistance 변수에 저장, (calculateDistance()에는 임의로 지정해놓은 상대방의 위도 경도가 있어서 계산됨)
    5. 거리가 계산되면 FutureBuilder 내부에 calculateDistance()를 인스턴스로 선언해놓은 calcDistance에 상대방과 나의 거리 값을 저장
    6. carouselItems의 userDistance에 거리를 업데이트
    7. imageSlider위젯의 userInfoList부분에 carouselItems를 넣어줘서 화면에 띄워주게됨
    */

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<List<dynamic>>(
                // future: Future.wait([
                //   userDataController.initLocation(), // 내 위치 가져오기
                //   userDataController.getUserData(), // 추천받을 유저 띄우기
                //   userDataController.getLoginData() // 로그인된 유저 정보 가져오기
                // ]),
                future: () async {
                  // 리스트로 집어넣어서 순서를 줌으로써 기존의 future빌더의 wait의 모두 실행될때까지라는 조건의 단점을 보완함 (이거 안해주면 null값 불러와서 오류남)
                  List results = [];
                  results.add(
                      await userDataController.initLocation()); // 내 위치 가져오기
                  results.add(
                      await userDataController.userGrantUpdate()); // 권한 업데이트
                  results.add(await userDataController
                      .getUserData()); // 먼저 내 위치를 업데이트 해주고 추천받을 유저 띄우기
                  results.add(await userDataController
                      .getLoginData()); // 로그인된 유저 정보 가져오기
                  return results;
                }(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // if (snapshot.hasData && snapshot.data?.length == 2) {
                    if (snapshot.hasData) {
                      // ================== 조건부 Select ==================
                      Position? userPosition = snapshot.data?[0]; // 현재 내 위치
                      List? userList = snapshot.data?[2]; // db에서 불러온 유저 정보 리스트
                      List? loginData = snapshot.data?[3]; // 로그인된 유저의 데이터

                      // print("로그인된 유저닉네임: ${loginData![0]['unickname']}");
                      // print(
                      //     "로그인된 유저권한: ${loginData[0]['ugender'] == "0" ? "남성" : "여성"}");
                      // print(
                      //     "로그인된 유저권한: ${loginData[0]['ugrant'] == 1 ? "구독자" : "무료 사용자"}");
                      // print("로그인된 유저 채팅카운트: ${loginData[0]['uchatcount']}");

                      if (loginData != null) {
                        // 유저에게 결제해서 권한이 있을경우 얼굴 이미지 띄워줌
                        if (loginData[0]['ugrant'] == 1) {
                          userImagepath1 = userList![0]['ufaceimg1'];
                          userImagepath2 = userList[1]['ufaceimg1'];
                          userImagepath3 = userList[2]['ufaceimg1'];
                        } else {
                          userImagepath1 = userList![0]['udogimg'];
                          userImagepath2 = userList[1]['udogimg'];
                          userImagepath3 = userList[2]['udogimg'];
                        }
                      }
                      //
                      if (userList != null) {
                        userDataController.userList(
                            userList); // 컨트롤러의 userList 변수에 불러온 snapshot.data?[1] 넘겨주기
                      }
                      // 흡연 여부에따라 흡연자 비흡연자를 알려주는 함수
                      isSmoke() {
                        List<String> uSmoke = [];
                        for (int i = 0; i < userList!.length; i++) {
                          uSmoke.add(userList[i]['usmoke'] == "1" ? "🚬" : "❌");
                        }
                        return uSmoke;
                      }

                      // 이미지와 텍스트 가지는 데이터 리스트
                      final List<SliderlItems> carouselItems = [
                        // 첫번째 유저
                        SliderlItems(
                            userId: userList![0]['uid'],
                            userMainImagePath: userImagepath1,
                            userFaceImagePath1: userList[0]['ufaceimg1'],
                            userFaceImagePath2: userList[0]['ufaceimg2'],
                            userHobbyImagePath1: userList[0]['uhobbyimg1'],
                            userHobbyImagePath2: userList[0]['uhobbyimg2'],
                            userHobbyImagePath3: userList[0]['uhobbyimg3'],
                            userDogImagePath: userList[0]['udogimg'],
                            userName: userList[0]['unickname'],
                            userAge: "${userDataController.ageCalc()[0]}세",
                            userAddress: userList[0]['uaddress'],
                            userDistance: reciveUserDistance,
                            userMBTI: userList[0]['umbti'],
                            userBreed: userList[0]['ubreed'],
                            userSmoke: isSmoke()[0],
                            loginUid: loginData![0]['uid'],
                            loginGrant: loginData[0]['ugrant'],
                            loginName: loginData[0]['unickname'],
                            loginChatCount: loginData[0]['uchatcount']),
                        // 두번째 유저
                        SliderlItems(
                            userId: userList[1]['uid'],
                            userMainImagePath: userImagepath2,
                            userFaceImagePath1: userList[1]['ufaceimg1'],
                            userFaceImagePath2: userList[1]['ufaceimg2'],
                            userHobbyImagePath1: userList[1]['uhobbyimg1'],
                            userHobbyImagePath2: userList[1]['uhobbyimg2'],
                            userHobbyImagePath3: userList[1]['uhobbyimg3'],
                            userDogImagePath: userList[1]['udogimg'],
                            userName: userList[1]['unickname'],
                            userAge: "${userDataController.ageCalc()[1]}세",
                            userAddress: userList[1]['uaddress'],
                            userDistance: reciveUserDistance,
                            userMBTI: userList[1]['umbti'],
                            userBreed: userList[1]['ubreed'],
                            userSmoke: isSmoke()[1],
                            loginUid: loginData[0]['uid'],
                            loginGrant: loginData[0]['ugrant'],
                            loginName: loginData[0]['unickname'],
                            loginChatCount: loginData[0]['uchatcount']),
                        // 세번째 유저
                        SliderlItems(
                            userId: userList[2]['uid'],
                            userMainImagePath: userImagepath3,
                            userFaceImagePath1: userList[2]['ufaceimg1'],
                            userFaceImagePath2: userList[2]['ufaceimg2'],
                            userHobbyImagePath1: userList[2]['uhobbyimg1'],
                            userHobbyImagePath2: userList[2]['uhobbyimg2'],
                            userHobbyImagePath3: userList[2]['uhobbyimg3'],
                            userDogImagePath: userList[2]['udogimg'],
                            userName: userList[2]['unickname'],
                            userAge: "${userDataController.ageCalc()[2]}세",
                            userAddress: userList[2]['uaddress'],
                            userDistance: reciveUserDistance,
                            userMBTI: userList[2]['umbti'],
                            userBreed: userList[2]['ubreed'],
                            userSmoke: isSmoke()[2],
                            loginUid: loginData[0]['uid'],
                            loginGrant: loginData[0]['ugrant'],
                            loginName: loginData[0]['unickname'],
                            loginChatCount: loginData[0]['uchatcount']),
                      ];

                      // 유저의 위치를 가져와서 거리랑 단위 변환하는 과정
                      if (userPosition != null) {
                        List<double> distances = userDataController
                            .calculateDistances(); // 컨트롤러에서 거리 계산하는 인스턴스
                        if (distances.length >= 2) {
                          double distanceWithUser1 =
                              distances[0]; // 첫 번째 사용자와의 거리
                          double distanceWithUser2 =
                              distances[1]; // 두 번째 사용자와의 거리
                          double distanceWithUser3 =
                              distances[2]; // 두 번째 사용자와의 거리
                          String user1DistanceText =
                              getFormattedDistance(distanceWithUser1);
                          String user2DistanceText =
                              getFormattedDistance(distanceWithUser2);
                          String user3DistanceText =
                              getFormattedDistance(distanceWithUser3);

                          carouselItems[0].userDistance = user1DistanceText;
                          carouselItems[1].userDistance = user2DistanceText;
                          carouselItems[2].userDistance = user3DistanceText;
                        }

                        // 성별에 따라 다른 배경컬러 적용
                        Color genderColors() {
                          bool user1IsMale = userList[0]['ugender'] == "0";

                          // 여성일 때와 남성일 때의 색상을 Map에 정의
                          Map<bool, Color> colorMap = {
                            true: const Color.fromARGB(
                                255, 67, 136, 196), // 남성 색상
                            false: const Color.fromARGB(
                                255, 154, 47, 187), // 여성 색상
                          };

                          return colorMap[user1IsMale] ?? Colors.black;
                        }

                        // ================== 조건부 Select ==================

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                '${loginData[0]['unickname']}님을 위한 추천',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  MainPageDetail(onChangeTheme: onChangeTheme),
                                  arguments: {
                                    'items': carouselItems,
                                    'index': indicatorCurrent.current,
                                  },
                                );
                                // print("carouselItems: $carouselItems");
                              },
                              child: Container(
                                // 여기가 전체 슬라이더 크기를 담당
                                color: genderColors(),
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // 화면 최대 넓이
                                height: 600,
                                child: Stack(
                                  children: [
                                    GetBuilder<IndicatorCurrent>(
                                      builder: (controller) {
                                        return CarouselSliderWidget(
                                          controller: sliderController,
                                          userInfoList: carouselItems,
                                          current: controller.current,
                                        );
                                      },
                                      //   CarouselSliderWidget(
                                      //     controller: sliderController,
                                      //     userInfoList: carouselItems,
                                      //     current: controller.current,
                                      //   );
                                      // },
                                    ),
                                    CarouselIndicator(
                                      userInfoList: carouselItems,
                                      current: indicatorCurrent.current,
                                      controller: sliderController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('위치를 가져오는 중에 오류가 발생했습니다: ${snapshot.error}');
                    }
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} // ---- Functions ----

// 거리 단위 함수
String getFormattedDistance(double distance) {
  return '${distance >= 1000.0 ? (distance / 1000.0).toStringAsFixed(2) : distance.toStringAsFixed(2)}${distance >= 1000.0 ? "Km" : "m"}';
}

