import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 이미지 불러오기 위젯
showImageWidget({required unickname, required double size}) {
  final userDataController = Get.find<LoadUserData>();
  return FutureBuilder<String>(
    future: userDataController.showUserImages(unickname: unickname),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // 로딩 중일 때
      } else if (snapshot.hasError) {
        return const Icon(Icons.error); // 에러 발생 시
      } else if (snapshot.hasData) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // 그림자의 위치
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return const Icon(
          Icons.person,
          size: 60,
        ); // 예상치 못한 경우
      }
    },
  );
}
