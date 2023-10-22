import 'package:blind_dating/view/chats.dart';
import 'package:blind_dating/view/favorite.dart';
import 'package:blind_dating/view/mainpage.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:flutter/material.dart';

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
          const Chats(),         // 진 채팅 페이지       
          const Profile()        // ?? 프로필 페이지
        ]
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