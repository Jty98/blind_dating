import 'package:blind_dating/components/detail_imageSlider_widget.dart';
import 'package:blind_dating/model/sliderItems_model.dart';
import 'package:blind_dating/viewmodel/indicatorCurrent_crtl.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageDetail extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  MainPageDetail({super.key, required this.onChangeTheme});

  // class 아래 BuildContext 위에 유저 데이터를 관리하는 컨트롤러 인스턴스 선언
  final LoadUserData userDataController = Get.put(LoadUserData());
  // final CarouselController carouselController; // CarouselController 인스턴스
  final IndicatorCurrent indicatorCurrent = Get.put(IndicatorCurrent());
  // 이미지 슬라이더를 제어하기 위한 기본적인 컨트롤러
  final CarouselController sliderController = CarouselController();
  // final List<SliderlItems> userInfoList; // 슬라이더에 담길 것들 가지고있는 리스트
  @override
  Widget build(BuildContext context) {
    // // Get.arguments를 통해 데이터 맵을 가져오기
    final Map<String, dynamic> data = Get.arguments;

    // 아이템과 인덱스 뽑아서 저장
    final List<SliderlItems> receivedItems = data['items'];
    final RxInt index = data['index']; // RxInt로 받음

    final RxInt current;
    // RxInt를 int로 변환
    final int intIndex = index.value;
    final SliderlItems currentItem =
        receivedItems[intIndex]; // 유저의 정보를 index로 구분

    final int loginGrant = currentItem.loginGrant;
    String userName = currentItem.userName;
    final String userBreed = currentItem.userBreed;

    final String detailInfoName =
        loginGrant == 1 ? "$userName님" : "이 $userBreed";

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Text(
            "$detailInfoName의 은밀한 정보",
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            closeDetailPage(); // 디테일페이지 인디케이터 index 초기화
            Get.back(); 
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<IndicatorCurrent>(
                builder: (controller) {
                  return DetailImageSliderWidget(
                    controller: sliderController,
                    userInfoList: receivedItems,
                    detailCurrent: controller.detailCurrent,
                    onChangeTheme: onChangeTheme,
                  );
                },
              ),
              // DetailCarouselIndicatorWidget(
              //   controller: sliderController,
              //   userInfoList: receivedItems,
              //   detailCurrent: indicatorCurrent.detailCurrent,
              // ),
              const SizedBox(height: 50),
              // DetailUserInfoWidget(),
            ],
          ),
        ),
      ),
      // ),
    );
  }

// 디테일 창을 닫을 때
  void closeDetailPage() {
    // detailCurrent 값을 원하는 값으로 설정하여 초기화
    indicatorCurrent.detailCurrent.value = 0; // 0으로 초기화
  }
}// --- Functions ---










            // FutureBuilder(
            //   future: userDataController.getLoginData(),
            //   // 에러 처리 로직 추가 가능
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.hasData) {
            //         List loginData = snapshot.data!; // 로그인된 유저의 데이터
            //         // 데이터가 있다면 여기 화면이 그려짐 (원치 않을경우 이부분 없애고 그냥 전역변수에 저장시키는 용도로 써도됨)
            //         return Column(
            //           children: [
            //             Text("User ID: ${loginData[0]['uid']}"),
            //             // 여기서 불러오고 싶은거 불러오면 됨 loginData[0]['unickname'] 하면 유저 닉네임 불러와짐
            //           ],
            //         );
            //         // -----
            //       } else {
            //         return const Text("데이터 없음");
            //       }
            //     } else if (snapshot.connectionState ==
            //         ConnectionState.waiting) {
            //       return const CircularProgressIndicator();
            //     } else {
            //       return const Text("데이터 로딩 중 오류 발생");
            //     }
            //   },
            // ),
