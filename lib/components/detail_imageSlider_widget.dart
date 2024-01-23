// ignore_for_file: file_names

import 'dart:ui';

import 'package:blind_dating/model/sliderItems_model.dart';
import 'package:blind_dating/view/paymentspage.dart';
import 'package:blind_dating/viewmodel/indicatorCurrent_crtl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class DetailImageSliderWidget extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const DetailImageSliderWidget(
      {super.key,
      required this.controller,
      required this.userInfoList,
      required this.detailCurrent,
      required this.onChangeTheme});

  final CarouselController controller; // CarouselController 인스턴스
  final List<SliderlItems> userInfoList; // 슬라이더에 담길 것들 가지고있는 리스트
  final RxInt detailCurrent; // 바뀌는 current를 알기위해 RxInt로 선언

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 자식 위젯을 세로 중앙에 배치
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 각각의 위젯에 정보 넣어주기
          detailImageSliderWidget(
              controller: controller,
              userInfoList: userInfoList,
              detailCurrent: detailCurrent),
          DetailCarouselIndicatorWidget(
              controller: controller,
              userInfoList: userInfoList,
              detailCurrent: detailCurrent),
          DetailUserInfoWidget(onChangeTheme: onChangeTheme),
        ],
      ),
    );
  }
}

// 디테일창 이미지 슬라이더 위젯
// ignore: camel_case_types
class detailImageSliderWidget extends StatelessWidget {
  final CarouselController controller;
  final List<SliderlItems> userInfoList;
  final RxInt detailCurrent;
  // final List items = SliderlItems as List;

  const detailImageSliderWidget({
    super.key,
    required this.controller,
    required this.userInfoList,
    required this.detailCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    final List<SliderlItems> receivedItems = data['items'];
    // ignore: non_constant_identifier_names
    final RxInt Index = data['index']; // RxInt로 받음

    // final RxInt detailCurrent;
    // RxInt를 int로 변환
    final int intIndex = Index.value;
    final SliderlItems currentItem =
        receivedItems[intIndex]; // 유저의 정보를 index로 구분

    final String userImagePath1 = currentItem.userDogImagePath; // 닮은 견종 사진
    final String userImagePath2 = currentItem.userFaceImagePath1; // 얼굴 사진1
    final String userImagePath3 = currentItem.userFaceImagePath2; // 얼굴 사진2
    final String userImagePath4 = currentItem.userHobbyImagePath1; // 취미 사진1
    final String userImagePath5 = currentItem.userHobbyImagePath2; // 취미 사진2
    final String userImagePath6 = currentItem.userHobbyImagePath3; // 취미 사진3
    final int loginGrant = currentItem.loginGrant; // 로그인된 유저 구독 여부
    final String userName = currentItem.userName; // 유저 이름
    final String userBreed = currentItem.userBreed; // 유저 견종

    List<String> imagesUrl = [
      currentItem.userDogImagePath,
      currentItem.userFaceImagePath1,
      currentItem.userFaceImagePath2,
      currentItem.userHobbyImagePath1,
      currentItem.userHobbyImagePath2,
      currentItem.userHobbyImagePath3,
    ];

// final List<Widget> images = [];

    final String detailInfoName =
        loginGrant == 1 ? "$userName님" : "이 $userBreed";

    // final List<String> images = [];
    List<Widget> images = [];
    final List<String> categories = loginGrant == 1
        ? ["닮은 강아지", "얼굴사진1", "얼굴사진2", "취미힌트1", "취미힌트2", "취미힌트3"]
        : [
            "닮은 강아지",
            "Premium 구독시 보입니다",
            "Premium 구독시 보입니다",
            "취미힌트1",
            "취미힌트2",
            "취미힌트3"
          ];
    int currentIndex = 0; // 슬라이드의 현재 페이지 인덱스

    // images리스트에 이미지 추가 과정
    if (loginGrant == 1) {
      for (int i = 0; i < categories.length; i++) {
        images.add(
          SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: imagesUrl[i],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      }
    } else {
      for (int i = 0; i < categories.length; i++) {
        if (i == 1 || i == 2) {
          images.add(SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 500,
            child: CachedNetworkImage(
              imageUrl: imagesUrl[i],
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  Image(
                    image: imageProvider,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                  ),
                  ClipRRect(
                    // ClipRRect가 없으면 상위 위젯까지 감싸서 잔상이 생겨버림
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
        } else {
          images.add(
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: imagesUrl[i],
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        }
      }
    }

    return Column(
      children: [
        CarouselSlider(
          items: images.asMap().entries.map((entry) {
            // asMap은 이미지 entry로는 배열에 담긴 문자 뽑아오기
            final int index = entry.key;
            // final dynamic imageUrl = entry.value;
            final String category = categories[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                images[index]
              ],
            );
          }).toList(),
          options: CarouselOptions(
            height: 550,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              detailCurrent.value = index;
            },
          ),
        ),
      ],
    );
  }
}

// 디테일창 유저 정보 위젯
class DetailUserInfoWidget extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const DetailUserInfoWidget({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    final List<SliderlItems> receivedItems = data['items'];
    final RxInt Index = data['index']; // RxInt로 받음

    // final RxInt detailCurrent;
    // RxInt를 int로 변환
    final int intIndex = Index.value;
    final SliderlItems currentItem =
        receivedItems[intIndex]; // 유저의 정보를 index로 구분

    final int loginGrant = currentItem.loginGrant;
    final int loginChatCount = currentItem.loginChatCount;
    final String loginUName = currentItem.loginName;
    final String userSmoke = currentItem.userSmoke;
    final String userName = currentItem.userName;
    final String userAge = currentItem.userAge;
    final String userAddress = currentItem.userAddress;
    final String userDistance = currentItem.userDistance;
    final String userMBTI = currentItem.userMBTI;
    final String loginUid = currentItem.loginUid;
    final String userid = currentItem.userId;
    final String loginName = currentItem.loginName;

    // 채팅 요청 보내기 위한 firebase instance 생성
    final FirebaseFirestore _requestChating = FirebaseFirestore.instance;

    void openBottomSheet() {
      if (loginGrant == 0 && loginChatCount > 0) {
        Get.defaultDialog(
            title: '채팅 보내기 ❤️',
            middleText: '채팅 기회가 $loginChatCount회 남았습니다\n 채팅을 진행하시겠습니까?',
            // backgroundColor: Colors.yellowAccent,
            barrierDismissible: true,
            actions: [
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        final requests = FirebaseFirestore.instance
                            .collection('requestChats')
                            .snapshots();
                        // requests['from'];
                        _requestChating.collection('requestChats').add({
                          'from': loginUid,
                          'to': userid,
                          'acceptState': 'wait',
                          'requestedAt': FieldValue.serverTimestamp()
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("$userName님께 채팅 요청을 보냈습니다."),
                              actions: [
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.back();
                                      },
                                      child: const Text("확인")),
                                )
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                          // backgroundColor: Colors.purple,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      child: const Text(
                        '채팅 요청하기',
                      )),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ]);
      } else if (loginGrant == 0 && loginChatCount < 1) {
        // 구독도 안하고 채팅 카운드도 다쓴경우
        Get.defaultDialog(
            title: '채팅 보내기 ❤️',
            middleText: '무료 채팅 기회가 모두 소진되었습니다.\n구독권 구매를 진행하시겠습니까?',
            // backgroundColor: Colors.yellowAccent,
            barrierDismissible: true,
            actions: [
              Column(
                children: [
                  TextButton(
                    onPressed: () => Get.to(() => PayMentsPage(
                          onChangeTheme: onChangeTheme,
                        )),
                    child: const Text('구매하기'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ]);
      } else {
        // 구독한 경우
        Get.defaultDialog(
            title: '채팅 보내기 ❤️',
            middleText: '채팅을 진행하시겠습니까?',
            // backgroundColor: Colors.yellowAccent,
            barrierDismissible: true,
            actions: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      _requestChating.collection('requestChats').add({
                        'from': loginUid,
                        'to': userid,
                        'acceptState': 'wait',
                        'requestedAt': FieldValue.serverTimestamp()
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("$userName님께 채팅 요청을 보냈습니다."),
                            actions: [
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      Get.back();
                                    },
                                    child: const Text("확인")),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('채팅 요청하기'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ]);
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(userAge),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text("$loginUName님과 마음의 거리 ❤️ $userDistance"),
                ],
              ),
            ),
          ],
        ),
        // 디테일 정보 시작
        Container(
          height: 2.0,
          width: MediaQuery.of(context).size.width, // 화면 최대 넓이
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "지역",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "MBTI",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "흡연여부",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userAddress),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userMBTI),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userSmoke),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => openBottomSheet(),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(94, 88, 176, 0.945),
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 40), // 버튼 사이즈 조절해서 통일성주기
              shape: RoundedRectangleBorder(
                // 버튼 모양 다듬기
                borderRadius: BorderRadius.circular(10),
              )),
          child: const Text(
            '대화 걸기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// indicator를 담당하는 위젯
class DetailCarouselIndicatorWidget extends StatelessWidget {
  final CarouselController controller;
  final List<SliderlItems> userInfoList;
  final RxInt detailCurrent;

  // indicator에 필요한 정보들
  const DetailCarouselIndicatorWidget({
    super.key,
    required this.controller,
    required this.userInfoList,
    required this.detailCurrent,
  });

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> data = Get.arguments;

    // final List<SliderlItems> receivedItems = data['items'];
    // final RxInt Index = data['index']; // RxInt로 받음

    // final int intIndex = Index.value;
    // final SliderlItems currentItem =
    //     receivedItems[intIndex]; // 유저의 정보를 index로 구분

    // final String userFaceImagePath1 = currentItem.userFaceImagePath1;
    // final String userFaceImagePath2 = currentItem.userFaceImagePath2;
    // final String userHobbyImagePath1 = currentItem.userHobbyImagePath1;
    // final String userHobbyImagePath2 = currentItem.userHobbyImagePath2;
    // final int loginGrant = currentItem.loginGrant;
    final List<String> images = [
      "닮은 강아지",
      "얼굴사진1",
      "얼굴사진2",
      "취미힌트1",
      "취미힌트2",
      "취미힌트3"
    ];

    return GetBuilder<IndicatorCurrent>(
      builder: (indicatorCurrent) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              // entry는 슬라이더의 인덱스에 담긴 모든걸 알고있는 Map항목임
              return GestureDetector(
                onTap: () {
                  controller.animateToPage(entry.key); // 이미지 슬라이더를 해당 페이지로 이동
                  indicatorCurrent.setDetailCurrent(
                      entry.key); // IndicatorCurrent 컨트롤러를 통해 페이지 변경
                },
                // indicator의 속성들을 정의하는 부분, Obx는 index마다 색이 바뀌기 때문에 이걸 옵져버로 알아야하기 때문에 감싸져있음
                child: Obx(() {
                  return Container(
                    width: 20,
                    height: 10,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal:
                            4.0), // 상하(vertical)로는 8.0, 좌우(horizontal)로는 4.0의 여백주기
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 동그라미 indicator생성
                      color: Colors.black.withOpacity(
                          detailCurrent.value == entry.key
                              ? 0.9
                              : 0.4), // 투명도를 조절하기 선택되면 더 어두운색 되게해줌
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
