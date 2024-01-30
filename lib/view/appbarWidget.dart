import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final LoadUserData userDataController = Get.put(LoadUserData());

    return FutureBuilder(
      future: Future.wait([userDataController.getLoginData()]),
      // 에러 처리 로직 추가 가능
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List? loginData = snapshot.data?[0]; // 로그인된 유저의 데이터
            loginData?[0]['unickname'];
            String grantMark = loginData?[0]['ugrant'] == 1
                ? "Premium🏅"
                : "남은 채팅횟수: ${loginData?[0]['uchatcount']}";

            // print("로그인된 앱바 유저닉네임: $unickname");
            return AppBar(
              title:
                  // Image.asset('images/반갑개Logo수정.jpeg',
                  //   width: 60,
                  //   height: 60,
                  // ),
                  const Text(
                "반갑개",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Text(
                    grantMark,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // 여기서 불러오고 싶은거 불러오면 됨 loginData[0]['unickname'] 하면 유저 닉네임 불러와짐
              ],
            );
          } else {
            return const Text("데이터 없음");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text("데이터 로딩 중 오류 발생");
        }
      },
    );
  }
}
