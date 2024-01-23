import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/login.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadUserData loadUserDataController = Get.put(LoadUserData());
    String userFacePath = "";

    getLoginData(loadUserDataController, userFacePath);
    // UserModel.setImageURL();
    // loginData
    print("userFacePath: $userFacePath");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(UserModel.imageURL),
            ),
            accountName: Text(
              '퍼그',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              'very@cute.com',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 69, 135, 249),
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => const Profile()),
            leading: const Icon(
              Icons.person,
              // color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('회원정보 수정'),
          ),
          ListTile(
            onTap: () {
              Get.defaultDialog(
                title: '로그아웃',
                middleText: '로그아웃 하시겠습니까?',
                backgroundColor: const Color.fromARGB(255, 123, 166, 241),
                barrierDismissible: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      // UserModel.clearAllProperties();
                      Get.to(() => const Login());
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      '아니오',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
            leading: const Icon(
              Icons.login,
              // color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('로그아웃'),
          ),
          ListTile(
            onTap: () {
              // Get.changeTheme(
              //   Get.isDarkMode ? CustomTheme.lighttheme : CustomTheme.darktheme,
              // );
            },
            leading: Get.isDarkMode
                ? Icon(Icons.sunny,
                    color: Theme.of(context).colorScheme.secondary)
                : Icon(Icons.dark_mode,
                    color: Theme.of(context).colorScheme.secondary),
            title: Get.isDarkMode
                ? const Text('라이트 테마 변경')
                : const Text('다크 테마 변경'),
          ),
        ],
      ),
    );
  }
  // --- Functions ---

  getLoginData(LoadUserData loadUserDataController, String userFacePath) {
    List loginData = loadUserDataController.loginData;

    if(loginData.isNotEmpty) {
       // 이미지 URL 추출
    userFacePath = loginData[0]['ufaceimg1'];
    UserModel.setImageURL(userFacePath);
    // String uhobbyimg1 = loginData[0]['uhobbyimg1'];
    // String uhobbyimg2 = loginData[0]['uhobbyimg2'];
    // String uhobbyimg3 = loginData[0]['uhobbyimg3'];
    }
  }


} //
