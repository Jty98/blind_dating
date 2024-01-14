import 'package:blind_dating/firebase_options.dart';
import 'package:blind_dating/home.dart';
import 'package:blind_dating/view/login.dart';
import 'package:blind_dating/view/phone_numbers_creen.dart';
import 'package:blind_dating/view/test_login.dart';
import 'package:blind_dating/viewmodel/chat_controller.dart';
import 'package:blind_dating/viewmodel/chat_request.dart';
import 'package:blind_dating/viewmodel/firebase_messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final ChatController chatController = Get.put(ChatController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final firebaseMessages = FirebaseMessages();
    // firebaseMessages.initNotifications();   // firebase messaging - 알림 수신 허용 요청
    
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}