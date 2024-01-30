import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/login.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:blind_dating/viewmodel/home_ctrl.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const MyDrawer({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final LoadUserData loadUserDataController = Get.put(LoadUserData());
    final HomeController homeController = Get.put(HomeController());
    String userFacePath = "";
    String loginNickName = "";

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
              radius: 100,
            ),
            accountName: Text(
              loadUserDataController.loginData[0]['unickname'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            accountEmail: Text(
              '닮은견종: ${loadUserDataController.loginData[0]['ubreed']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => Profile(
                  onChangeTheme: onChangeTheme,
                )),
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
                      Get.offAll(
                          () => Login(
                                onChangeTheme: onChangeTheme,
                              ),
                          transition: Transition.noTransition);
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
          Obx(
            () => ListTile(
              onTap: () {
                homeController.thmeStatus.value =
                    !homeController.thmeStatus.value;
                homeController.thmeStatus.value
                    ? onChangeTheme(ThemeMode.dark)
                    : onChangeTheme(ThemeMode.light);
              },
              leading: homeController.thmeStatus.value
                  ? Icon(Icons.sunny,
                      color: Theme.of(context).colorScheme.secondary)
                  : Icon(Icons.dark_mode,
                      color: Theme.of(context).colorScheme.secondary),
              title: homeController.thmeStatus.value
                  ? const Text('라이트 테마 변경')
                  : const Text('다크 테마 변경'),
            ),
          ),
        ],
      ),
    );
  }
  // --- Functions ---

  getLoginData(LoadUserData loadUserDataController, String userFacePath) {
    List loginData = loadUserDataController.loginData;

    if (loginData.isNotEmpty) {
      // 이미지 URL 추출
      userFacePath = loginData[0]['ufaceimg1'];
      UserModel.setImageURL(userFacePath);
      // String uhobbyimg1 = loginData[0]['uhobbyimg1'];
      // String uhobbyimg2 = loginData[0]['uhobbyimg2'];
      // String uhobbyimg3 = loginData[0]['uhobbyimg3'];
    }
  }
} //
