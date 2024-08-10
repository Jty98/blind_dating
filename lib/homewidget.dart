import 'package:blind_dating/components/mydrawer.dart';
import 'package:blind_dating/view/alarm.dart';
import 'package:blind_dating/view/appbarWidget.dart';
import 'package:blind_dating/view/chat_room_lists.dart';
import 'package:blind_dating/view/mainpage.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const HomeWidget({super.key, required this.onChangeTheme});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
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
    //     final Map<String, dynamic> data = Get.arguments;

    // final List<SliderlItems> receivedItems = data['items'];
    // final RxInt Index = data['index']; // RxInt로 받음

    // // final RxInt detailCurrent;
    // // RxInt를 int로 변환
    // final int intIndex = Index.value;
    // final SliderlItems currentItem =
    //     receivedItems[intIndex]; // 유저의 정보를 index로 구분

    // final int loginGrant = currentItem.loginGrant;
    // final String loginUName = currentItem.loginName;

    return Scaffold(
      appBar: const AppbarWidget(),
      body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MainPage(onChangeTheme: widget.onChangeTheme), // 태영 메인 페이지
            ChatRoomLists(), // 진 채팅 페이지
            // const FavoritePage(),
            const AlarmPage(),
            Profile(onChangeTheme: widget.onChangeTheme,) // ?? 프로필 페이지
          ]),
      drawer: MyDrawer(onChangeTheme: widget.onChangeTheme),
      // 화면 하단 탭바 설정
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.home),
            text: "Home",
          ),
          Tab(
            icon: Icon(Icons.chat_bubble_outline),
            text: "Chats",
          ),
          Tab(
            icon: Icon(Icons.notifications_rounded),
            text: "Alarms",
          ),
          Tab(
            icon: Icon(Icons.person),
            text: "Profile",
          )
        ],
      ),
    );
  }
}
