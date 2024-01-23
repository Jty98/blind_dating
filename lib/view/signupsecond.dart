import 'dart:convert';
import 'dart:io';
import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/view/signupthird.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:blind_dating/model/user.dart';


//image를 flask로 보내는 함수
// Future<String> uploadImage(XFile? imageFile) async {
//   final Uri uri = Uri.parse('http://ec2-52-78-36-96.ap-northeast-2.compute.amazonaws.com:5000/upload');
//   final http.MultipartFile file = await http.MultipartFile.fromPath('image', imageFile!.path);
//   final http.Request request = (http.MultipartRequest('POST', uri)..files.add(file)) as http.Request;
//   final http.StreamedResponse response = await request.send();
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseBody = json.decode(await response.stream.bytesToString());
//     return responseBody['results']; 
//   } else {
//     throw Exception('Failed to upload image');
//   }
// }
//2차수정
// Future<String> uploadImage(XFile? imageFile) async {
//   if (imageFile == null) {
//     throw Exception('No image provided');
//   }
  
//   final Uri uri = Uri.parse('http://ec2-52-78-36-96.ap-northeast-2.compute.amazonaws.com:5000/upload');
//   final http.MultipartFile file = await http.MultipartFile.fromPath('image', imageFile.path);

//   final http.MultipartRequest request = http.MultipartRequest('POST', uri);
//   request.files.add(file);

//   final http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseBody = json.decode(await response.stream.bytesToString());
//     return responseBody['results']; 
//   } else {
//     throw Exception('Failed to upload image');
//   }
// }

//3차수정
// Future<String?> uploadImage(XFile? imageFile) async {
//   if (imageFile == null) {
//     throw Exception('No image provided');
//   }
  
//   final Uri uri = Uri.parse('http://ec2-52-78-36-96.ap-northeast-2.compute.amazonaws.com:5000/upload');
//   final http.MultipartFile file = await http.MultipartFile.fromPath('image', imageFile.path);

//   final http.MultipartRequest request = http.MultipartRequest('POST', uri);
//   request.files.add(file);

//   final http.StreamedResponse response = await request.send();


//   print(response.stream);
//   // if (response.statusCode == 200) {
//   //   final Map<String, dynamic> responseBody = json.decode(await response.stream.bytesToString());
//   //   // return responseBody['results']; 
//   //   return json.encode(responseBody);

//   // } else {
//   //   throw Exception('Failed to upload image');
//   // }
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseBody = json.decode(await response.stream.bytesToString());
    
//     String? resultDogType;
//     responseBody.forEach((key, value) {
//       if (value == '100.00%') {
//         resultDogType = key;
//       }
//   });
  
//     if (resultDogType != null) {
//       return resultDogType;
//     } else {
//       throw Exception('No dog type matched 100.00%');
//     }
//   } else {
//     throw Exception('Failed to upload image');
//   }

// }

//4차수정
Future<String?> uploadImage(XFile? imageFile) async {
  if (imageFile == null) {
    throw Exception('No image provided');
  }

  final Uri uri = Uri.parse('http://ec2-52-78-36-96.ap-northeast-2.compute.amazonaws.com:5000/upload');
  final http.MultipartFile file = await http.MultipartFile.fromPath('image', imageFile.path);

  final http.MultipartRequest request = http.MultipartRequest('POST', uri);
  request.files.add(file);

  final http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = json.decode(await response.stream.bytesToString());

    String? resultDogType;
    responseBody.forEach((key, value) {
      if (double.parse(value.replaceAll('%', '')) >= 90.0) {
        resultDogType = key;
      }
    });

    if (resultDogType != null) {
      // 반환된 강아지 종류를 user.dart의 ubreed 변수에 저장합니다.
      UserModel.ubreed = resultDogType!;

      // 반환된 강아지 종류의 이름에 해당하는 .png 이미지 경로를 user.dart의 udogimg 변수에 저장합니다.
      // 이미지의 경로는 프로젝트의 구조에 따라 적절히 수정해야 합니다.
      UserModel.udogimg = 'path_to_images/$resultDogType.png';

      return resultDogType;
    } else {
      throw Exception('No dog type matched 100.00%');
    }
  } else {
    throw Exception('Failed to upload image');
  }
}


Stream<String> waitingTextStream() async* {
  int count = 0;
  while (true) {
    await Future.delayed(Duration(milliseconds: 500));
    count = (count + 1) % 4;  // 0, 1, 2, 3 순서로 반복
    String dots = '.' * count;
    yield '결과를 기다리는중$dots';
  }
}

class SignUpSecond extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const SignUpSecond({Key? key, required this.onChangeTheme}) : super(key: key);

  @override
  State<SignUpSecond> createState() => _SignUpSecondState();
}




class _SignUpSecondState extends State<SignUpSecond> {
  XFile? _photoImage;
  XFile? _galleryImage;
  bool hasReceivedResult = false; //모델결과값 받아오기 전까지는 다음버튼 비활성화
  final ImagePicker picker = ImagePicker();
  String? dogTypeResult; // 강아지 종류를 저장하는 변수
  bool isButtonPressed = false; // 버튼이 눌렸는지 여부


  Future getImage(ImageSource imageSource) async {
    
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      if (imageSource == ImageSource.camera) {
        setState(() {
          _photoImage = pickedFile;
        });
      } else {
        setState(() {
          _galleryImage = pickedFile;
        });
      }
    }
  }

  Widget _buildGalleryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              getImage(ImageSource.gallery);
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
            SizedBox(width: 20), // 간격을 위해 추가한 코드
      ElevatedButton.icon(
      onPressed: () async {
    if (_galleryImage == null) {
      // TODO: 사용자에게 이미지가 선택되지 않았음을 알리는 메시지 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('에러'),
          content: Text('이미지가 선택되지 않았습니다\n 이미지를 선택해서 "닮은 강아지 찾기"를 눌러주세요'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
      return;
    } else {
      setState(() {
        hasReceivedResult = false;
        isButtonPressed = true; // 이미지가 선택되었을 때만 버튼이 눌렸다고 표시
      });

      try {
        dogTypeResult = await uploadImage(_galleryImage); // 결과를 dogTypeResult에 저장

        if (dogTypeResult != null) {
          // 결과 팝업을 띄우는 코드
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('결과'),
                content: Text('닮은 강아지 종류: $dogTypeResult'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        setState(() {
          hasReceivedResult = true;
        });
      } catch (e) {
        // TODO: 오류 메시지 표시
        print("Error: $e");
      }
    }
},

          style: TextButton.styleFrom(
              minimumSize: Size(130, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Color.fromARGB(255, 152, 175, 250),
              foregroundColor: Color.fromARGB(255, 234, 234, 236)),
          icon: Icon(Icons.pets),
          label: Text(
            "닮은 강아지 찾기",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      ],
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '       사진을 등록하세요\n 닮은 강아지를 찾아줄게요',
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
                Image.asset('images/stepsecond.png'),
                // SizedBox(height: 35),
                // _buildPhotoArea(),
                SizedBox(height: 35),
                // _buildButton(),
                SizedBox(height: 25),
                _buildGalleryArea(),
                SizedBox(height: 25),
                _buildGalleryButton(),
                if (isButtonPressed && !hasReceivedResult) 
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: Text('닮은 강아지: ${dogTypeResult ?? '결과를 기다리는 중...'}'),
                // ),
                StreamBuilder<String>(
                  stream: waitingTextStream(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('닮은 강아지: ${dogTypeResult ?? snapshot.data}'),
                      );
                    }
                    return SizedBox.shrink();  // 스트림에서 아직 데이터가 도착하지 않은 경우에 대한 위젯 (예: 로딩 인디케이터나 다른 위젯)
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 75, 15, 80),
                  child: ElevatedButton(
                    onPressed: hasReceivedResult ? () {
                      Get.to(() => SignUpThird(onChangeTheme: widget.onChangeTheme,));
                    } : null,
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
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildPhotoArea() {
    return _photoImage != null
        ? Container(
            width: 300,
            height: 300,
            child: Image.file(File(_photoImage!.path)),
          )
        : Container(
            width: 300,
            height: 300,
            color: Color.fromARGB(255, 212, 221, 247),
          );
  }

  Widget _buildGalleryArea() {
  return Stack(
    children: [
      _galleryImage != null
          ? Container(
              width: 300,
              height: 300,
              child: Image.file(File(_galleryImage!.path)),
            )
          : Container(
              width: 300,
              height: 300,
              color: Color.fromARGB(255, 212, 221, 247),
            ),
      if (_galleryImage != null)
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _galleryImage = null;
              });
            },
          ),
        ),
    ],
  );
}
}

  // Widget _buildButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       ElevatedButton.icon(
  //           onPressed: () {
  //             getImage(ImageSource.camera);
  //           },
  //           style: TextButton.styleFrom(
  //               minimumSize: Size(130, 50),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               backgroundColor: Color.fromARGB(255, 152, 175, 250),
  //               foregroundColor: Color.fromARGB(255, 234, 234, 236)),
  //           icon: Icon(Icons.photo),
  //           label: Text(
  //             "카메라",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           )),
  //     ],
  //   );
  // }
// }
