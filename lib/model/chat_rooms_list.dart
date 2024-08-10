class ChatRoomsList {
  String ufaceimg1;
  String unickname;
  // String timeStamp;

  ChatRoomsList({
    required this.ufaceimg1,
    required this.unickname,
    // required this.timeStamp
  });

  factory ChatRoomsList.fromJson(Map<String, dynamic> json) {
    return ChatRoomsList(
      ufaceimg1: json['ufaceimg1'],
      unickname: json['unickname'],
      // timeStamp: json['timeStamp'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ufaceimg1': ufaceimg1,
      'unickname': unickname,
      // 'created_at': Timestamp.now() // 채팅방이 생성된 (가장 첫 메시지 전송) 시각
    };
  }
}
