import 'package:blind_dating/util/theme.dart';
import 'package:blind_dating/view/chat_room_lists.dart';
import 'package:blind_dating/view/chats.dart';
import 'package:blind_dating/view/favorite.dart';
import 'package:blind_dating/view/mainpage.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with SingleTickerProviderStateMixin{

  // property
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("소🐶팅"),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          MainPage(),      // 태영 메인 페이지
          const FavoritePage(),
          const ChatRoomLists(),         // 진 채팅 페이지       
          const Profile()        // ?? 프로필 페이지
        ]
      ),
      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [ 
          UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('images/퍼그.png',),
            radius: 200,
          ),
          accountName: Text('퍼그', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),), 
          accountEmail: Text('very@cute.com', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
          decoration: BoxDecoration(color: const Color.fromARGB(255, 69, 135, 249),),
          ),
          ListTile(onTap: () {
              Get.to(Profile());
            },
            leading: Icon(Icons.person,
            // color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('회원정보 수정'),
          ),
          ListTile(
            onTap: () {
              // Get.to(ShowLogout())
            },
            leading: Icon(Icons.login,
            // color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('로그아웃'),
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
      
      ),
      // 화면 하단 탭바 설정
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: const [
          Tab(
            icon: Icon(
              Icons.home
            ),
            text: "Home",
          ),
          Tab(
            icon: Icon(
              Icons.favorite
            ),
            text: "Favorites",
          ),
          Tab(
            icon: Icon(
              Icons.chat_bubble_outline
            ),
            text: "Chats",
          ),
          Tab(
            icon: Icon(
              Icons.person
            ),
            text: "Profile",
          )
        ],
      ),
    );
  }
}