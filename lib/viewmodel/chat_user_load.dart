import 'package:blind_dating/viewmodel/loadUserData_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

/// Descriptions: Firebase에서 채팅 목록을 가져오기 위해서 Firebase chatrooms 정보를 가져오는 쿼리문
///               로직: 1. chatRooms데이터 중에서 accepter목록에 현재 로그인된 유저의 unickname과 일치하는 것을 뽑아옴
///                    2. 가져온 목록들 중 contracter들의 이미지 정보를 가져옴 (원래는 Firebase에서 다 가져와야하지만 현재 구조가 완벽하지 않기 때문에 MySQL에서 들고오기)

class ChatRoomController extends GetxController {
  final LoadUserData userDataController = Get.put(LoadUserData());

  var loginData = <String, dynamic>{}.obs;
  var chatRooms = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() async {
    await loadLoginData();
    super.onInit();
  }

  Future loadLoginData() async {
    try {
      var data = await userDataController.getLoginData();
      if (data != null && data.isNotEmpty) {
        loginData.value = data[0];
        loadChatRooms();
      }
    } catch (e) {
      print('Error loading login data: $e');
    }
  }

  void loadChatRooms() {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .where('accepter', isEqualTo: loginData['unickname'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      chatRooms.value = snapshot.docs;
    });
  }
}
