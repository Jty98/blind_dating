class UserModel {
  static String ufaceimg1 = ''; // 유저 얼굴 이미지 1
  static String ufaceimg2 = ''; // 유저 얼굴 이미지 2
  static String uhobbyimg1 = ''; // 유저 취미 이미지 1
  static String uhobbyimg2 = ''; // 유저 취미 이미지 2
  static String uhobbyimg3 = ''; // 유저 취미 이미지 3
  static String userName = ''; // 유저 이름
  static String ugender = ''; // 유저 성별
  static String uaddress = ''; // 유저 주소
  static String unickname= ''; // 유저 닉네임
  static String umbti = ''; // 유저 MBTI
  static String ubirth = ''; // 유저 생일
  static String ubreed = ''; // 유저 견종
  static String udogimg = ''; // 유저 견종
  static String usmoke = ''; // 유저 흡연 여부
  static String uid = ''; // 유저 아이디
  static String upw = ''; // 유저 비밀번호
  static String loginUid = ''; // 로그인된 유저 ID
  static String loginName = ''; // 로그인된 유저 이름
  static String imageURL = '';
  static int ugrant = 0; // 유저의 구독권 권한 여부 (0: 무료, 1: 구독)

  // 이미지 URL을 UserModel의 imageURL 변수에 저장하는 함수
  static void setImageURL(String url) {
    imageURL = url;
  }

  // 함수를 사용하여 모든 속성을 비움
  static void clearAllProperties() {
    ufaceimg1 = '';
    ufaceimg2 = '';
    uhobbyimg1 = '';
    uhobbyimg2 = '';
    uhobbyimg3 = '';
    udogimg = '';
    userName = '';
    ugender = '';
    uaddress = '';
    unickname = '';
    umbti = '';
    ubirth = '';
    ubreed = '';
    usmoke = '';
    uid = '';
    upw = '';
    loginUid = '';
    loginName = '';
    imageURL = '';
    ugrant = 0;
  }

  UserModel();

  // MBTI 정보를 UserModel의 umbti 변수에 저장하는 함수
  // static void setMBTI(String mbti) {
  //   umbti = mbti;
  // }

}
