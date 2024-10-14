import 'package:blind_dating/components/image_widget.dart';
import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:get/get.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  //// property
  // 채팅방 목록에서 넘겨받은 arguments: [chatRoomId, 상대 uid, 상대 unickname]
  var value = Get.arguments ?? '__';
  // class 아래 BuildContext 위에 유저 데이터를 관리하는 컨트롤러 인스턴스 선언
  final userDataController = Get.find<LoadUserData>();
  // 사용자 로그인 정보 받아둘 리스트
  late List loginData = [];
  late List userData = []; // 상대 사용자
  // 사용자와 메시지 전송자 일치 여부
  late bool isSender;

  final FirebaseFirestore chatRoomsRef = FirebaseFirestore.instance;

  // 메시지 작성 text field controller
  late TextEditingController textEditingController;
  // 화면 스크롤 조정 컨트롤러
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${value[2]}'),
      ),
      body: FutureBuilder(
        future: userDataController.getLoginData(),
        // 에러 처리 로직 추가 가능
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              loginData = snapshot.data!; // 로그인된 유저의 데이터
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(value[0])
                    .collection('chats')
                    // .where('chatRoomId', isEqualTo: '${value[0]}')
                    .orderBy('chatedAt', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('오류 발생: ${snapshot.error.toString()}');
                    return Center(
                      child: Text('오류 발생: ${snapshot.error.toString()}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final chats = snapshot.data!.docs;

                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              // 새로운 채팅이 생기면 아래로 당겨지기 위해서 reversedIndex 사용
                              final reversedIndex = chats.length - 1 - index;
                              return _buildItemWidget(doc: chats[reversedIndex],);
                            },
                          ),
                        ), // firebase에서 받아온 메시지
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: textEditingController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10)),
                                  style: const TextStyle(fontSize: 20),
                                  onSubmitted: (textFieldValue) {
                                    // 엔터키 눌렀을 때 firebase에 텍스트 필드 내용이 전송되도록
                                    FirebaseFirestore.instance
                                        .collection('chatRooms')
                                        .doc(value[0])
                                        .collection('chats')
                                        .add({
                                      // 'content': textEditingController.text,
                                      'content': textFieldValue,
                                      'sender': loginData[0]['uid'],
                                      'chatedAt': FieldValue.serverTimestamp()
                                    });
                                    textEditingController.clear();
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // firebase로 메시지 추가하는 기능
                                  FirebaseFirestore.instance
                                      .collection('chatRooms')
                                      .doc(value[0])
                                      .collection('chats')
                                      .add({
                                    'content': textEditingController.text,
                                    'sender': loginData[0]['uid'],
                                    'chatedAt': FieldValue.serverTimestamp()
                                  });
                                  textEditingController
                                      .clear(); // 메시지 추가 후 필드 지우기
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
        },
      ),
    );
  }

  Widget _buildItemWidget(
      {required DocumentSnapshot doc,
      // required String uNcikname,
      // required String mesage
      }) {
    final content = doc['content'];
    final sender = doc['sender'];
    // final chatedAt = doc['chatedAt'];
    // int dateHour = chatedAt.toDate().hour;
    // // 시간을 12시간제로 변환
    // String chatTime = (dateHour > 12)
    //   ? '${(dateHour - 12).toString().padLeft(2, '0')}:${chatedAt.minute.toString().padLeft(2, '0')} PM'
    //   : '${dateHour.toString().padLeft(2, '0')}:${chatedAt.minute.toString().padLeft(2, '0')} ${dateHour < 12 ? 'AM' : 'PM'}';
    // // 0 AM을 12 AM으로 표시
    // chatTime = (chatTime.startsWith('00')) ? '12${chatTime.substring(2)}' : chatTime;

    return loginData[0]['uid'] == sender
        ? Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BubbleSpecialThree(
                  text: content,
                  color: const Color.fromARGB(255, 133, 195, 246),
                  isSender: true,
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                showImageWidget(uid: value[1], size: 50),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            value[2],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          BubbleSpecialThree(
                            text: content,
                            color: const Color.fromARGB(255, 236, 234, 234),
                            isSender: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
