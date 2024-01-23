import 'dart:io';
import 'package:blind_dating/model/user.dart';
import 'package:blind_dating/view/signupfourth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpThird extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpThird({super.key, required this.onChangeTheme});

  @override
  State<SignUpThird> createState() => _SignUpThirdState();
}

class _SignUpThirdState extends State<SignUpThird> {
  // 프로필 이미지 및 취미 이미지를 저장하는 리스트
  List<XFile?> _imageprofile = List.generate(2, (_) => null);
  List<XFile?> _imagehobby = List.generate(3, (_) => null);
  final ImagePicker picker = ImagePicker();

  // 이미지 가져오는 함수
  Future getImage(int index, ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        if (index < _imageprofile.length) {
          _imageprofile[index] = pickedFile; // 프로필 이미지 리스트에 저장
        } else if (index < _imageprofile.length + _imagehobby.length) {
          _imagehobby[index - _imageprofile.length] =
              pickedFile; // 취미 이미지 리스트에 저장
        }
      });
    }
  }

  Future<String> loadImageURL(String path) async {
    Reference _ref = FirebaseStorage.instance.ref().child(path);
    try {
      String url = await _ref.getDownloadURL();
      return url;
    } catch (e) {
      print('FirebaseException: $e'); // 에러 발생 시 예외 던지기
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(94, 88, 176, 0.945),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
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
                Image.asset('images/stepthird.png'),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 180, 0),
                  child: Text(
                    '프로필 사진을 등록해 주세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 54, 54, 58),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 0, width: double.infinity),
                _buildPhotoArea(),
                SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // 프로필 이미지와 URL을 UserModel에 저장
                //       saveProfileImageURLs();
                //     },
                //     style: TextButton.styleFrom(
                //       minimumSize: Size(100, 40),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       backgroundColor: Color.fromARGB(255, 152, 175, 250),
                //       foregroundColor: Color.fromARGB(255, 234, 234, 236),
                //     ),
                //     child: Text(
                //       '프로필 사진 저장',
                //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 190, 0),
                  child: Text(
                    '취미 사진을 등록해 주세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 54, 54, 58),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPhotoHobbyArea(),
                SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // 취미 이미지와 URL을 UserModel에 저장
                //       saveHobbyImageURLs();
                //     },
                //     style: TextButton.styleFrom(
                //       minimumSize: Size(100, 40),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       backgroundColor: Color.fromARGB(255, 152, 175, 250),
                //       foregroundColor: Color.fromARGB(255, 234, 234, 236),
                //     ),
                //     child: Text(
                //       '취미 사진 저장',
                //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 50, 15, 80),
                  child: ElevatedButton(
                    onPressed: () {
                      // 이미지 저장 여부를 확인하여 다음 화면으로 이동
                      checkImagesStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 50),
                      backgroundColor: Color.fromARGB(255, 146, 148, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "다음",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 234, 236),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 프로필 이미지가 모두 업로드되었는지 확인하는 함수
  bool areAllProfileImagesUploaded() {
    return _imageprofile.every((element) => element != null);
  }

  // 취미 이미지가 모두 업로드되었는지 확인하는 함수
  bool areAllHobbyImagesUploaded() {
    return _imagehobby.every((element) => element != null);
  }

  // 이미지 업로드 상태를 확인하여 사용자에게 메시지를 표시하는 함수
  void checkImagesStatus() {
    if (!areAllProfileImagesUploaded()) {
      Get.snackbar(
        "ERROR",
        "프로필 사진을 선택해 주세요.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 247, 228, 162),
      );
    } else if (!areAllHobbyImagesUploaded()) {
      Get.snackbar(
        "ERROR",
        "취미 사진을 선택해 주세요.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 252, 199, 249),
      );
    } else {
      // 프로필 이미지와 취미 이미지가 모두 선택되면 UserModel에 저장 후, SignUpFourth로 이동
      saveProfileImageURLs();
      saveHobbyImageURLs();
      Get.to(() => SignUpFourth(onChangeTheme: widget.onChangeTheme,));
    }
  }

  Widget _buildPhotoArea() {
    // 프로필 이미지 영역 위젯
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          for (int i = 0; i < _imageprofile.length; i++)
            Row(
              children: [
                _buildImagePicker(i, _imageprofile),
                SizedBox(width: 10),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoHobbyArea() {
    // 취미 이미지 영역 위젯
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          for (int j = 0; j < _imagehobby.length; j++)
            Row(
              children: [
                _buildImagePicker(j, _imagehobby),
                SizedBox(width: 10),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(int index, List<XFile?> imageList) {
    return GestureDetector(
      onTap: () {
        if (imageList == _imageprofile) {
          getImage(index, ImageSource.gallery);
        } else if (imageList == _imagehobby) {
          getImage(index + _imageprofile.length, ImageSource.gallery);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 212, 221, 247),
          image: imageList[index] != null
              ? DecorationImage(
                  image: FileImage(File(imageList[index]!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageList[index] == null
            ? Icon(
                Icons.add_a_photo,
                size: 48,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }

  // 프로필 이미지 URL을 UserModel에 저장하는 함수
  Future<void> saveProfileImageURLs() async {
    List<String> profileImageURLs = [];
    for (XFile? file in _imageprofile) {
      if (file != null) {
        String url = await uploadImageAndGetURL(
            'user/profile/${UserModel.uid}_profile_${profileImageURLs.length + 1}',
            File(file.path));
        profileImageURLs.add(url);
      }
    }
    UserModel.ufaceimg1 =  profileImageURLs[0];
    UserModel.ufaceimg2 = profileImageURLs[1];
    UserModel.ufaceimg1 = profileImageURLs.length > 0 ? profileImageURLs[0] : '';
    UserModel.ufaceimg2 = profileImageURLs.length > 1 ? profileImageURLs[1] : '';
    //UserModel.ufaceimg1 = '${UserModel.uid}_profile_1';
    //UserModel.ufaceimg2 = '${UserModel.uid}_profile_2';

    print('ufaceimg1: ${UserModel.ufaceimg1}');
    print('ufaceimg2: ${UserModel.ufaceimg2}');
  }

  // 취미 이미지 URL을 UserModel에 저장하는 함수
  Future<void> saveHobbyImageURLs() async {
    List<String> hobbyImageURLs = [];
    for (XFile? file in _imagehobby) {
      if (file != null) {
        String url = await uploadImageAndGetURL(
            'user/hobby/${UserModel.uid}_hobby_${hobbyImageURLs.length + 1}',
            File(file.path));
        hobbyImageURLs.add(url);
      }
    }
    UserModel.uhobbyimg1 = hobbyImageURLs.length > 0 ? hobbyImageURLs[0] : '';
    UserModel.uhobbyimg2 = hobbyImageURLs.length > 1 ? hobbyImageURLs[1] : '';
    UserModel.uhobbyimg3 = hobbyImageURLs.length > 2 ? hobbyImageURLs[2] : '';
    // UserModel.uhobbyimg1 = hobbyImageURLs[0];
    // UserModel.uhobbyimg2 = hobbyImageURLs[1];
    // UserModel.uhobbyimg3 = hobbyImageURLs[2];

    // UserModel.uhobbyimg1 = '${UserModel.uid}_hobby_1';
    // UserModel.uhobbyimg2 = '${UserModel.uid}_hobby_2';
    // UserModel.uhobbyimg3 = '${UserModel.uid}_hobby_3';

    print('uhobbyimg1: ${UserModel.uhobbyimg1}');
    print('uhobbyimg2: ${UserModel.uhobbyimg2}');
    print('uhobbyimg3: ${UserModel.uhobbyimg3}');
  }

  // // 이미지를 Firebase Storage에 업로드하고 URL을 얻는 함수
  // Future<String> uploadImageAndGetURL(String path, File file) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference ref = storage.ref().child(path);
  //   UploadTask uploadTask = ref.putFile(file);

  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadURL = await snapshot.ref.getDownloadURL();
  //   print("Download URL: $downloadURL");
  //   return downloadURL;
  // }


// 이미지를 Firebase Storage에 업로드하고 URL을 얻는 함수
Future<String> uploadImageAndGetURL(String path, File file) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child(path);
  UploadTask uploadTask = ref.putFile(file);

  TaskSnapshot snapshot = await uploadTask;
  String downloadURL = await snapshot.ref.getDownloadURL();
  String encodedURL = Uri.encodeFull(downloadURL);  // URL 인코딩 추가
  print("Download URL: $encodedURL");
  return encodedURL;  // 인코딩된 URL 반환
}










}
