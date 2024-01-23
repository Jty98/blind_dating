import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/login.dart';
import 'package:blind_dating/view/profilemodify.dart';
import 'package:blind_dating/view/signupfirst.dart';
import 'package:blind_dating/view/signupsecond.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController SubscriptionController;
  late TextEditingController ContractController;
  late Future<String> imageURL;

  @override
  void initState() {
    super.initState();
    SubscriptionController = TextEditingController();
    ContractController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(UserModel.imageURL),
                      radius: 100,
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => ProfileModify());
                    },
                    style: TextButton.styleFrom(
                        minimumSize: Size(170, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(255, 146, 148, 255),
                        foregroundColor: Color.fromARGB(255, 234, 234, 236)),
                    child: Text(
                      '프로필 수정',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 88, 104, 126),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '구독 서비스',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 135,
                      ),
                      IconButton(
                          onPressed: () {
                            Get.to(HomeWidget());
                          },
                          icon: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
                Divider(
                  // 실선 추가
                  color: Colors.grey, // 실선 색상 설정
                  thickness: 1, // 실선의 두께 설정
                  indent: 50, // 실선의 시작 위치 설정
                  endIndent: 50, // 실선의 끝 위치 설정
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment,
                        color: Color.fromARGB(255, 88, 104, 126),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '이용약관/개인정보 취급 방침',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(Container(
                              height: 500,
                              width: 500,
                              color: Color.fromARGB(255, 217, 217, 217),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      '-개인정보 이용약관-',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '*개인정보 수집 및 이용 목적*',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '회사는 사용자의 개인정보를 다음 목적을 위해 수집하고 사용합니다.'),
                                    Text('가입, 회원 로그인, 회원탈퇴'),
                                    Text('서비스 제공 및 운영'),
                                    Text('고객 지원 및 문의 응대'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '*수집하는 개인정보 항목*',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('회사는 다음과 같은 개인정보를 수집할 수 있습니다'),
                                    Text('회원 가입 및 로그인 정보: 이름, 이메일 주소, 비밀번호'),
                                    Text(
                                        '서비스 이용 기록: 접속 일시, 서비스 이용 기록, 기기 정보, 쿠키 및 로그 데이터'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '*개인정보의 보유 및 이용 기간*',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '회사는 사용자의 개인정보를 수집한 목적이 달성되거나 개인정보 보유 및 이용기간이 경과한 경우 \n 해당 정보를 지체 없이 파기합니다.'),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          },
                          icon: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
                Divider(
                  // 실선 추가
                  color: Colors.grey, // 실선 색상 설정
                  thickness: 1, // 실선의 두께 설정
                  indent: 50, // 실선의 시작 위치 설정
                  endIndent: 50, // 실선의 끝 위치 설정
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
