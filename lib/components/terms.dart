import 'package:flutter/material.dart';

class Terms {
  /// 이용약관 다이얼로그 함수
  termsDialog({required BuildContext context, required String arguments}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('이용약관'),
          content: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: 350,
              child: Text(
                arguments,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(minimumSize: const Size(200, 30)),
                  child: const Text('확인'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
