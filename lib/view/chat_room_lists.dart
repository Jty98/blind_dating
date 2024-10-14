import 'package:blind_dating/components/image_widget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/chats.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomLists extends StatefulWidget {
  ChatRoomLists({super.key});

  @override
  State<ChatRoomLists> createState() => _ChatRoomListsState();
}

class _ChatRoomListsState extends State<ChatRoomLists> {
  final LoadUserData userDataController = Get.put(LoadUserData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('accepter', isEqualTo: UserModel.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('StreamBuilder error: ${snapshot.error}');
            return Center(child: Text('오류 발생: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRoomsDocs = snapshot.data!.docs;

          // 각 채팅방의 최신 채팅 시간으로 정렬하기 위해 FutureBuilder 사용
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: Stream.fromFuture(_fetchChatRooms(chatRoomsDocs)),
            builder: (context, chatRoomSnapshot) {
              if (chatRoomSnapshot.hasError) {
                print('Inner StreamBuilder error: ${chatRoomSnapshot.error}');
                return Center(
                    child: Text('오류 발생: ${chatRoomSnapshot.error.toString()}'));
              }
              if (!chatRoomSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chatRoomsWithLatestChats = chatRoomSnapshot.data!;

              return ListView.builder(
                    itemCount: chatRoomsWithLatestChats.length,
                    itemBuilder: (context, index) {
                      final chatRoomData = chatRoomsWithLatestChats[index];
                      final chatRoomDoc = chatRoomData['doc'];
                      final latestChatedAt =
                          chatRoomData['latestChatedAt'] as Timestamp;
                      final chatRoomId = chatRoomDoc.id;
                      final contacter = chatRoomDoc['contacter'];
                      // final createdAt = chatRoomDoc['createdAt'];
                      final chatRoomName = (UserModel.uid == contacter
                          ? chatRoomDoc['accepter']
                          : chatRoomDoc['contacter']);
                  
                      return FutureBuilder<String>(
                        future: userDataController.selectChatUserInfo(
                            uid: chatRoomName),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (userSnapshot.hasError) {
                            print(
                                'User FutureBuilder error: ${userSnapshot.error}');
                            return Center(
                                child: Text(
                                    '오류 발생: ${userSnapshot.error.toString()}'));
                          }
                          if (!userSnapshot.hasData) {
                            return const Center(child: Text('사용자 정보 로드 실패'));
                          }
                  
                          final userName = userSnapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Get.to(const Chats(), arguments: [
                                chatRoomId,
                                chatRoomName,
                                userName,
                              ])!
                                  .then((_) {
                                // 채팅 후 돌아왔을 때 상태 업데이트
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                leading:
                                    showImageWidget(uid: chatRoomName, size: 60),
                                title: Row(
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                        child: Text(
                                          '${latestChatedAt.toDate().year}년 ${latestChatedAt.toDate().month}월 ${latestChatedAt.toDate().day}일',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  chatRoomData['lastMessage'] ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
            },
          );
        },
      ),
    );
  }

  // chatRooms 세부 컬렉션인 chats를 불러오기
  Future<List<Map<String, dynamic>>> _fetchChatRooms(
      List<QueryDocumentSnapshot> chatRoomsDocs) async {
    final futures = chatRoomsDocs.map((chatRoomDoc) async {
      final chatRoomId = chatRoomDoc.id;
      final chatSnapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('chats')
          .orderBy('chatedAt', descending: true)
          .limit(1)
          .get();

      final latestChatedAt = chatSnapshot.docs.isNotEmpty
          ? chatSnapshot.docs.first['chatedAt']
          : chatRoomDoc['createdAt'];

      return {
        'doc': chatRoomDoc,
        'latestChatedAt': latestChatedAt,
        'lastMessage': chatSnapshot.docs.isNotEmpty
            ? chatSnapshot.docs.first['content']
            : '',
      };
    }).toList();

    final chatRooms = await Future.wait(futures);
    chatRooms.sort((a, b) {
      final aTime = a['latestChatedAt'] as Timestamp;
      final bTime = b['latestChatedAt'] as Timestamp;
      return bTime.compareTo(aTime);
    });

    return chatRooms;
  }
}
