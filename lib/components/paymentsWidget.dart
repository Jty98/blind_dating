import 'package:blind_dating/homewidget.dart';
import 'package:blind_dating/util/arguments.dart';
import 'package:blind_dating/view/mainpage.dart';
import 'package:blind_dating/viewmodel/payments_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayMentsWidget extends StatelessWidget {
  const PayMentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PayMentsController payMentsController = Get.put(PayMentsController());

    bool? allOk = false; // 전체 동의 체크박스
    bool electronicPay = false; // 전자금융거래 동의 체크박스
    bool userInfoUseage = false; // 개인정보 수집 동의 체크박스
    bool userInfoThirdParties = false; // 제 3자 정보제공 동의 체크박스

    String selectedPaymentsList = "";
    Future<String> uid = payMentsController.initSharedPreferences();
    ;
    RxString upw = payMentsController.selectedPayment;

    //     Future<String> initSharedPreferences() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   uid = prefs.getString('uid') ?? " ";
    //   upw = prefs.getString('upw') ?? " ";
    //   print("pay send uid: $uid");
    //   print("pay send upw: $upw");
    //   return uid;
    // }

    // 전자거래 이용약관
    electroPayDialog() {
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
                  Arguments.Electronic_Financial_Transactions,
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
                    style:
                        TextButton.styleFrom(minimumSize: const Size(200, 30)),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    // 개인정보 사용 이용약관
    userInfoUseageDialog() {
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
                  Arguments.Personal_Information_Useage,
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
                    style:
                        TextButton.styleFrom(minimumSize: const Size(200, 30)),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    // 제3자 이용약관
    userInfoThirdPartiesDialog() {
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
                  Arguments.Personal_Information_Third_Parties,
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
                    style:
                        TextButton.styleFrom(minimumSize: const Size(200, 30)),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    // 결제 성공 결과
    void purchaseSuccsessResultDialog() {
      Get.defaultDialog(
        title: 'Primium 구독권 결제가\n완료되었습니다!',
        middleText: '이제 마음에 드는 이성과 자유롭게 채팅해보세요!',
        // backgroundColor: Colors.yellowAccent,
        barrierDismissible: true,
        actions: [
          Column(
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.to((const HomeWidget()));
                  // Get.back();
                },
                child: const Text("확인"),
              ),
            ],
          )
        ],
      );
    }
    // 결제 실패 결과
    void failedDialog() {
      Get.defaultDialog(
        title: '결제에 실패했습니다 😢',
        middleText: '결제 수단을 다시 확인해주세요.',
        // backgroundColor: Colors.yellowAccent,
        barrierDismissible: true,
        actions: [
          Column(
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("확인"),
              ),
            ],
          )
        ],
      );
    }

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Color.fromARGB(255, 186, 60, 51),
                    width: MediaQuery.of(context).size.width, // 화면 최대 넓이
                    height: 250,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "반갑개",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Premium 구독권 30일권 결제",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 2.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "결제금액",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "29,900원",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white, // 하단 하얀색 배경
                    width: MediaQuery.of(context).size.width,
                    height: 180, // 하단 높이
                  ),
                ],
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 350) / 2,
                top: (100 + 200) / 2 + 40,
                child: Container(
                  color: Colors.white,
                  width: 350,
                  height: 220,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "이용약관",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 130,
                            ),
                            Obx(
                              () => Checkbox(
                                value: payMentsController.checkAll.value,
                                onChanged: (value) {
                                  payMentsController.funcAllCheck(value!);
                                },
                              ),
                            ),
                            const Text("전체동의"),
                          ],
                        ),
                      ),
                      Container(
                        height: 2.0,
                        width: 300,
                        color: Colors.grey,
                      ),
                      // 전자거래 동의 행
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: payMentsController.electronicPay.value,
                                onChanged: (value) {
                                  payMentsController.funcElectroCheck(value!);
                                  // payMentsController.electronicPay(value!);
                                },
                              ),
                            ),
                            const Text("전자금융거래 이용약관"),
                            const SizedBox(
                              width: 85,
                            ),
                            TextButton(
                              onPressed: () => electroPayDialog(),
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(30, 30)),
                              child: const Text("보기"),
                            ),
                          ],
                        ),
                      ),
                      // 개인정보 동의 행
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: payMentsController.userInfoUsage.value,
                                onChanged: (value) {
                                  // payMentsController.userInfoUsage(value!);
                                  payMentsController.funcUserInfoCheck(value!);
                                },
                              ),
                            ),
                            const Text("개인정보 수집/이용안내"),
                            const SizedBox(
                              width: 80,
                            ),
                            TextButton(
                              onPressed: () => userInfoUseageDialog(),
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(30, 30)),
                              child: const Text("보기"),
                            ),
                          ],
                        ),
                      ),
                      // 제3자 정보동의 행
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: payMentsController
                                    .userInfoThirdParties.value,
                                onChanged: (value) {
                                  payMentsController.funcUserInfoThirdPartiesCheck(value!);
                                },
                              ),
                            ),
                            const Text("개인정보 제3자 제공/위탁안내"),
                            const SizedBox(
                              width: 42,
                            ),
                            TextButton(
                              onPressed: () => userInfoThirdPartiesDialog(),
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(30, 30)),
                              child: const Text("보기"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 2.0,
                        width: 300,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "결제수단",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                ),
                width: 350,
                height: 280,
                child: Obx(
                  () => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("삼성카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "삼성카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "삼성카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("국민카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "국민카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "국민카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("롯데카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "롯데카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "롯데카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("신한카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "신한카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "신한카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("현대카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "현대카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "현대카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                payMentsController.funcSelectPayment("비씨카드");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.grey),
                                backgroundColor:
                                    payMentsController.selectedPayment.value ==
                                            "비씨카드"
                                        ? Colors.grey
                                        : Colors.white,
                              ),
                              child: const Text(
                                "비씨카드",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                // db에 결제 업데이트시키기
                // if (payMentsController.electronicPay == false && payMentsController.userInfoUsage == false && payMentsController.userInfoThirdParties == false){
                if (payMentsController.checkAll == false) {
                  print("전부 동의 필요");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '이용약관에 전부 동의해주세요.',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      duration: Duration(seconds: 1), // 2초 보이기
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (payMentsController.selectedPayment == "") {
                  print("결제수단을 선택해주세요.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '결제수단을 선택해주세요.',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      duration: Duration(seconds: 1), // 2초 보이기
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // 결제 진행
                  print("결제 진행되었고 결제수단은 ${payMentsController.selectedPayment}");
                  if (await payMentsController.purchaseAction(1)) {
                    // 상품 코드만 넣어서 결제 진행
                    purchaseSuccsessResultDialog();
                    // Get.to(MainPage());
                  } else{
                    failedDialog();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  backgroundColor: Colors.red,
                  maximumSize: const Size(150, 40)),
              child: const Text(
                "결제",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
