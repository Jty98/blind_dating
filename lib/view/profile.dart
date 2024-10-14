import 'package:blind_dating/components/image_widget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/paymentspage.dart';
import 'package:blind_dating/view/profilemodify.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Profile extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const Profile({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: showProfileImageWidget(
                    imageUrl: UserModel.imageURL,
                    size: 300,
                    context: context),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => ProfileModify(
                          onChangeTheme: onChangeTheme,
                        ));
                  },
                  style: TextButton.styleFrom(
                      minimumSize: const Size(170, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor:
                          const Color.fromARGB(255, 146, 148, 255),
                      foregroundColor:
                          const Color.fromARGB(255, 234, 234, 236)),
                  child: const Text(
                    '프로필 수정',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications,
                      color: Color.fromARGB(255, 88, 104, 126),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      '구독 서비스',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 135,
                    ),
                    IconButton(
                        onPressed: () {
                          // Get.to(HomeWidget(onChangeTheme: widget.onChangeTheme,));
                          Get.to(() => PayMentsPage(
                                onChangeTheme: onChangeTheme,
                              ));
                        },
                        icon: const Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
              const Divider(
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
                    const Icon(
                      Icons.assignment,
                      color: Color.fromARGB(255, 88, 104, 126),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      '이용약관/개인정보 취급 방침',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            height: 500,
                            width: 500,
                            color: const Color.fromARGB(255, 217, 217, 217),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
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
                        icon: const Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
              const Divider(
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
    );
  }
}
