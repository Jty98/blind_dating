import 'package:blind_dating/components/image_widget.dart';
import 'package:blind_dating/view/chats.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    // get the notification message and display on screen
    // final messages = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    // final messages = Get.arguments as RemoteMessage;

    // class 아래 BuildContext 위에 유저 데이터를 관리하는 컨트롤러 인스턴스 선언
    final userDataController = Get.find<LoadUserData>();
    // 사용자 로그인 정보 받아둘 리스트
    late List loginData = []; // 현재 사용자
    late List userData = []; // 상대 사용자
    final FirebaseFirestore _requestCollection = FirebaseFirestore.instance;
    late DocumentSnapshot requestCollection;

    _requestCollection
        .collection('requestChats')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        // requestColl
        requestCollection = doc;
        // return requestCollection;
      }
    });

    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([userDataController.getLoginData()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                loginData = snapshot.data![0];

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('requestChats')
                      .where('to', isEqualTo: '${loginData[0]['uid']}')
                      .where('acceptState',
                          whereIn: ['wait', 'hold']).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('오류 발생: ${snapshot.error.toString()}'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final chatReqestDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: chatReqestDocs.length,
                      itemBuilder: (context, index) {
                        // firebase 불러오기
                        final chatRequest = chatReqestDocs[index];
                        final from = chatRequest['from'];
                        final to = chatRequest['to'];
                        final acceptState = chatRequest['acceptState'];
                        final requestedAt = chatRequest['requestedAt'].toDate();

                        // 시간 형식 계산
                        DateTime now = DateTime.now();
                        bool isSameDay(DateTime date1, DateTime date2) {
                          return date1.year == date2.year &&
                              date1.month == date2.month &&
                              date1.day == date2.day;
                        }

                        String requestedTime(DateTime dateTime) {
                          int dateTime = requestedAt.hour;
                          // DateFormat을 사용하여 12시간 형식(AM/PM)으로 시간 변환
                          String requestedTime = dateTime > 12
                              ? '${(dateTime - 12).toString().padLeft(2, '0')}:${requestedAt.minute.toString().padLeft(2, '0')} PM'
                              : '${dateTime.toString().padLeft(2, '0')}:${requestedAt.minute.toString().padLeft(2, '0')} ${dateTime < 12 ? 'AM' : 'PM'}';
                          // 0 AM을 12 AM으로 표시
                          requestedTime = (requestedTime.startsWith('00'))
                              ? '12${requestedTime.substring(2)}'
                              : requestedTime;
                          return requestedTime;
                        }

                        return Visibility(
                          visible: ((loginData[0]['uid'] == from) ||
                                  (loginData[0]['uid'] == to)) &&
                              ((acceptState == 'hold') ||
                                  (acceptState == 'wait')),
                          child: FutureBuilder<String>(
                            future: userDataController.selectChatUserInfo(
                                uid: from),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (userSnapshot.hasError) {
                                return const Icon(Icons.error);
                              } else if (userSnapshot.hasData) {
                                return Card(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: showImageWidget(
                                              uid: to, size: 50),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '"${userSnapshot.data}"님의 채팅 요청',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  _updateRequest(
                                                      requestCollection
                                                          .reference,
                                                      'accept');
                                                  // 채팅방 개설
                                                  FirebaseFirestore.instance
                                                      .collection('chatRooms')
                                                      .add({
                                                    'accepter': loginData[0]
                                                        ['unickname'],
                                                    'contacter': userData[0]
                                                        ['unickname'],
                                                    'createdAt': FieldValue
                                                        .serverTimestamp()
                                                  });
                                                  // 다이어로그
                                                },
                                                child: const Text("수락"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _updateRequest(
                                                      requestCollection
                                                          .reference,
                                                      'hold');
                                                },
                                                child: const Text("보류"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // 파베 상태 업데이트
                                                  _updateRequest(
                                                      requestCollection
                                                          .reference,
                                                      'reject');
                                                },
                                                child: const Text("거부"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            isSameDay(requestedAt, now)
                                                ? requestedTime(requestedAt)
                                                : isSameDay(
                                                        requestedAt,
                                                        now.subtract(
                                                            const Duration(
                                                                days: 1)))
                                                    ? "어제"
                                                    : (requestedAt.year !=
                                                            now.year)
                                                        ? "${requestedAt.year}년 ${requestedAt.month}월 ${requestedAt.day}일"
                                                        : '${requestedAt.month}월 ${requestedAt.day}일',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(child: Text("데이터 못불러옴"));
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Text("데이터 없음");
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return const Text("데이터 로딩 중 오류 발생");
            }
          }),
    );
  }

  Future<void> _updateRequest(DocumentReference chatReq, String state) async {
    await chatReq.update({'acceptState': state});
  }
}
