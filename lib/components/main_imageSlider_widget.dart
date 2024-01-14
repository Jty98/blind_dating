// ignore_for_file: file_names

import 'package:blind_dating/model/sliderItems_model.dart';
import 'package:blind_dating/viewmodel/indicatorCurrent_crtl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// View에서 불러와서 바로 쓰게끔 하나로 합치는 클래스이며 위젯 2개를 합쳐서 씀 (따로따로 dart파일 만들어서 하는게 좋은건지 이게 좋은지 모름)
class ImageSliderWidget extends StatelessWidget {
  final CarouselController controller; // CarouselController 인스턴스
  final List<SliderlItems> userInfoList; // 슬라이더에 담길 것들 가지고있는 리스트
  final RxInt current; // 바뀌는 current를 알기위해 RxInt로 선언

  const ImageSliderWidget({
    super.key,
    required this.controller,
    required this.userInfoList,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 각각의 위젯에 정보 넣어주기
        CarouselSliderWidget(
            controller: controller,
            userInfoList: userInfoList,
            current: current),
        CarouselIndicator(
            controller: controller,
            userInfoList: userInfoList,
            current: current),
      ],
    );
  }
}

// Slider부분을 담당하는 위젯
class CarouselSliderWidget extends StatelessWidget {
  final CarouselController controller;
  final List<SliderlItems> userInfoList;
  final RxInt current;

  // Slider에 필요한 정보들
  const CarouselSliderWidget({
    super.key,
    required this.controller,
    required this.userInfoList,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    print("userInfoList: $userInfoList");
    return CarouselSlider(
      carouselController: controller,
      items: userInfoList.map((item) {
        return Stack(
          children: [
            SizedBox(
              // 이미지 크기
              width: MediaQuery.of(context).size.width, // 화면 최대 넓이
              height: 510,
              child: Image.network(item.userMainImagePath, fit: BoxFit.cover),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.userName,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(item.userAge,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("지역: ${item.userAddress}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text("현재위치: ${item.userDistance}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("MBTI: ${item.userMBTI}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text("견종: ${item.userBreed}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
      options: CarouselOptions(
        // height: MediaQuery.of(context).size.height, // slider 감싼 높이랑 같게 해주는게 좋음, 화면의 최대 높이로 설정
        height: MediaQuery.of(context)
            .size
            .height, // slider 감싼 높이랑 같게 해주는게 좋음, 화면의 최대 높이로 설정
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        onPageChanged: (index, reason) {
          current.value = index; // 페이지 변경 시 current 업데이트
        },
      ),
    );
  }
}

// indicator를 담당하는 위젯
class CarouselIndicator extends StatelessWidget {
  final CarouselController controller;
  final List<SliderlItems> userInfoList;
  final RxInt current;

  // indicator에 필요한 정보들
  const CarouselIndicator({
    super.key,
    required this.controller,
    required this.userInfoList,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndicatorCurrent>(
      builder: (indicatorCurrent) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: userInfoList.asMap().entries.map((entry) {
              // entry는 슬라이더의 인덱스에 담긴 모든걸 알고있는 Map항목임
              return GestureDetector(
                onTap: () {
                  controller.animateToPage(entry.key); // 이미지 슬라이더를 해당 페이지로 이동
                  indicatorCurrent.setCurrent(
                      entry.key); // IndicatorCurrent 컨트롤러를 통해 페이지 변경
                },
                // indicator의 속성들을 정의하는 부분, Obx는 index마다 색이 바뀌기 때문에 이걸 옵져버로 알아야하기 때문에 감싸져있음
                child: Obx(() {
                  return Container(
                    width: 20,
                    height: 12,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal:
                            4.0), // 상하(vertical)로는 8.0, 좌우(horizontal)로는 4.0의 여백주기
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 동그라미 indicator생성
                      color: Colors.black.withOpacity(current.value == entry.key
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
