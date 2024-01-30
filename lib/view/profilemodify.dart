import 'dart:convert';
import 'dart:io';

import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileModify extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const ProfileModify({super.key, required this.onChangeTheme});

  @override
  State<ProfileModify> createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  late Map<String, dynamic> userdata; // Map으로 수정
  late TextEditingController IDController;
  late TextEditingController PWController;
  late TextEditingController PWCheckController;
  late TextEditingController AddressController;
  late TextEditingController NickNameController;
  late Future<String> imageURL;

  late String inputValue;

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  Future<String> loadImageURL(String path) async {
    print('path: $path');
    Reference _ref = FirebaseStorage.instance.ref().child(path);
    String url = await _ref.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    super.initState();
    late Map<String, dynamic> userdata = {};
    getJSONData();
    IDController = TextEditingController(text: UserModel.uid);
    // IDController = TextEditingController(text: '임시아이디');
    PWController = TextEditingController();
    PWCheckController = TextEditingController();
    AddressController = TextEditingController();
    NickNameController = TextEditingController();

    inputValue = "";
    imageURL = loadImageURL('user/profile/${UserModel.uid}_profile_1');
    // imageURL.then((url) {
    //   UserModel.setImageURL(url); // 이미지 URL을 UserModel의 imageURL 변수에 저장
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Get 패키지를 사용하여 이전 페이지로 이동합니다.
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5, width: double.infinity),
                // _buildPhotoArea(),
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(UserModel.imageURL),
                  radius: 100,
                ),
                SizedBox(height: 15),
                _buildButton(),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: TextStyle(fontSize: 16),
                    controller: IDController,
                    decoration: const InputDecoration(
                        hintText: '아이디',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 88, 104, 126),
                        )),
                    readOnly: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
                  child: TextField(
                      style: TextStyle(fontSize: 16),
                      controller: NickNameController,
                      decoration: const InputDecoration(
                          hintText: '닉네임',
                          prefixIcon: Icon(
                            Icons.person_add_alt_1,
                            color: Color.fromARGB(255, 88, 104, 126),
                          )),
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        inputValue = NickNameController.text;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: PWController,
                    decoration: const InputDecoration(
                        labelText: "비밀번호",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 88, 114, 126),
                        )),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      inputValue = PWController.text;
                    },
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: PWCheckController,
                    decoration: const InputDecoration(
                        labelText: "비밀번호 확인",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 88, 114, 126),
                        )),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      inputValue = PWCheckController.text;
                    },
                    obscureText: true,
                  ),
                ),
                Text(
                  '비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자로 입력해 주세요.',
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
                  child: TextField(
                      style: TextStyle(fontSize: 16),
                      controller: AddressController,
                      decoration: const InputDecoration(
                          hintText: '주소',
                          prefixIcon: Icon(
                            Icons.home,
                            color: Color.fromARGB(255, 88, 104, 126),
                          )),
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        inputValue = AddressController.text;
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 50),
                  child: ElevatedButton(
                      onPressed: () {
                        userInfoUpdate();
                        // updateShowDialog();
                      },
                      style: TextButton.styleFrom(
                          minimumSize: Size(170, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color.fromARGB(255, 146, 148, 255),
                          foregroundColor: Color.fromARGB(255, 234, 234, 236)),
                      child: Text(
                        '확인',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(300, 0, 0, 20),
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: '회원탈퇴',
                        middleText: '탈퇴 후 1주일간은 재가입이 불가합니다. \n 탈퇴하시겠습니까?',
                        backgroundColor: Color.fromARGB(255, 245, 153, 150),
                        barrierDismissible: false,
                        actions: [
                          TextButton(
                            onPressed: () {
                              userDelete();
                              Get.to(() => HomeWidget(
                                    onChangeTheme: widget.onChangeTheme,
                                  ));
                            },
                            child: Text(
                              '확인',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              '아니오',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    child: Text(
                      '회원탈퇴',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 253, 91, 79),
                        fontSize: 15, fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // 밑줄 추가
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 200,
            height: 200,
            // child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
            child: Image.network(UserModel.imageURL),
            //  CachedNetworkImage(UserModel.imageURL), //가져온 이미지를 화면에 띄워주는 코드
          )
        : FutureBuilder<String>(
            future: imageURL,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the image to load, you can display a loading indicator or placeholder.
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading image');
              } else {
                return Container(
                  width: 200,
                  height: 200,
                  child: snapshot.hasData
                      ? Image(image: NetworkImage(snapshot.data!))
                      : CircularProgressIndicator(),
                  color: Color.fromARGB(255, 212, 221, 247),
                );
              }
            });
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
            },
            style: TextButton.styleFrom(
                minimumSize: Size(130, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 152, 175, 250),
                foregroundColor: Color.fromARGB(255, 234, 234, 236)),
            icon: Icon(Icons.photo),
            label: Text(
              "갤러리",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  getJSONData() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_user_query_flutter.jsp?uid=${UserModel.uid}');
    var response = await http.get(url);
    // print(response.body);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> result = dataConvertedJSON['results'][0]; // Map으로 변경
    setState(() {
      userdata = result; // userdata에 Map으로 저장
      IDController = TextEditingController(text: userdata['uid']);
      NickNameController = TextEditingController(text: userdata['unickname']);
      AddressController = TextEditingController(text: userdata['uaddress']);
    });
  }

  userInfoUpdate() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_user_update_flutter.jsp?uid=${IDController.text}&unickname=${NickNameController.text}&uaddress=${AddressController.text}');
    var response = await http.get(url);
    print(response.body);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> result = {};
    if (dataConvertedJSON['results'] != null &&
        dataConvertedJSON['results'].isNotEmpty) {
      result = dataConvertedJSON['results'][0];
    } // Map으로 변경
    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).{8,15}$')
        .hasMatch(PWController.text)) {
      Get.snackbar(
        "Error",
        '비밀번호는 영문 대소문자, 숫자를 혼합하여 8~15자여야 합니다.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 232, 157, 157),
      );
    } else if (PWController.text != PWCheckController.text) {
      Get.snackbar(
        "Error",
        '비밀번호가 일치하지 않습니다.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 232, 157, 157),
      );
    } else {
      updateShowDialog();
    }
  }

  updateShowDialog() {
    Get.defaultDialog(
      title: '회원정보 수정',
      middleText: '회원정보가 수정되었습니다.',
      backgroundColor: Color.fromARGB(255, 59, 160, 237),
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.to(() => HomeWidget(
                  onChangeTheme: widget.onChangeTheme,
                ));
          },
          child: Text('확인'),
        ),
      ],
    );
  }

  userDelete() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/dateapp_user_delete_flutter.jsp?uid=${IDController.text}&udelete=1');
    var response = await http.get(url);
    print(response.body);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> result = {};

    if (dataConvertedJSON['result'] == 'OK') {
      // 회원 삭제 성공 시 수행할 작업
      Get.to(() => HomeWidget(
            onChangeTheme: widget.onChangeTheme,
          ));
    } else {
      // 회원 삭제 실패 시 수행할 작업
      // 에러 메시지를 표시하거나, 다른 동작을 수행할 수 있습니다.
    }
  }
}
