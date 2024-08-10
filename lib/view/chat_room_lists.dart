import 'package:blind_dating/components/image_widget.dart';
import 'package:blind_dating/model/chat_rooms_list.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/chats.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomLists extends StatelessWidget {
  final LoadUserData userDataController = Get.put(LoadUserData());
  ChatRoomLists({super.key});

  Map<String, dynamic> loginData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userDataController.getLoginData(),
        builder: (context, snapshot) {
          print('FutureBuilder state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print('FutureBuilder error: ${snapshot.error}');
              return Center(child: Text('오류 발생: ${snapshot.error.toString()}'));
            }

            if (snapshot.hasData) {
              // loginData = snapshot.data![0];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .where('accepter', isEqualTo: UserModel.unickname)
                    .orderBy('createdAt', descending: true) // createdAt 기준으로 정렬
                    .snapshots(),
                builder: (context, snapshot) {
                  print('StreamBuilder state: ${snapshot.connectionState}');
                  if (snapshot.hasError) {
                    print('StreamBuilder error: ${snapshot.error}');
                    return Center(
                        child: Text('오류 발생: ${snapshot.error.toString()}'));
                  }
                  if (!snapshot.hasData) {
                    print('StreamBuilder: 데이터 없음');
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chatRoomsDocs = snapshot.data!.docs;

                  // createdAt 기준으로 정렬
                  chatRoomsDocs.sort((a, b) {
                    Timestamp aCreatedAt = a['createdAt'];
                    Timestamp bCreatedAt = b['createdAt'];
                    return bCreatedAt.compareTo(aCreatedAt); // 내림차순 정렬
                  });

                  print('filteredChatRooms length: ${chatRoomsDocs.length}');

                  return ListView.builder(
                    itemCount: chatRoomsDocs.length,
                    itemBuilder: (context, index) {
                      final chatRoomId = chatRoomsDocs[index];
                      final contacter = chatRoomId['contacter'];
                      final createdAt = chatRoomId['createdAt'];
                      final chatRoomName = (UserModel.unickname == contacter
                          ? chatRoomId['accepter']
                          : chatRoomId['contacter']);

                      return FutureBuilder(
                        future: userDataController.selectChatUserInfo(
                            unickname: chatRoomName, createdAt: createdAt),
                        builder: (context, snapshot) {
                          print(
                              'Inner FutureBuilder state: ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(
                                'Inner FutureBuilder error: ${snapshot.error}');
                            return Center(
                                child: Text(
                                    '오류 발생: ${snapshot.error.toString()}'));
                          } else if (snapshot.hasData) {
                            final chatUserList =
                                snapshot.data as List<ChatRoomsList>;

                            // chatUserList의 데이터가 필터링된 인덱스와 일치하는지 확인
                            if (index < chatUserList.length) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(const Chats(), arguments: [
                                    chatRoomId.id,
                                    chatRoomName,
                                  ]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 0),
                                    leading:
                                        showImageWidget(unickname: chatRoomName, size: 60),
                                    title: Row(
                                      children: [
                                        Text(
                                          "$chatRoomName, $index",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child: Text(
                                              '${createdAt.toDate().year}년 ${createdAt.toDate().month}월 ${createdAt.toDate().day}일',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              print("dddd");
                              return Center(
                                  child: Text(
                                      "데이터 없음 listLength: ${chatRoomsDocs.length}"));
                            }
                          } else {
                            print('Inner FutureBuilder: 데이터 없음');
                            return const Center(child: Text("데이터 없음"));
                          }
                        },
                      );
                    },
                  );
                },
              );
            } else {
              print('FutureBuilder@@@@@@@@@@@@@@@@@@@@@@@@: 데이터 없음');
              return const Center(child: Text(""));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            print('FutureBuilder: 데이터 로딩 중 오류 발생');
            return const Center(child: Text("데이터 로딩 중 오류 발생"));
          }
        },
      ),
    );
  }
}
