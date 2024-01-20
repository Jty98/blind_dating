import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  late Position? currentPostion;

  bool canRun = false;
  RxDouble latData = 0.0.obs;
  RxDouble longData = 0.0.obs;
  double latitude = 0;
  double longitude = 0;

  @override
  void onInit() async {
    await checkLocationPermission();
    super.onInit();
  }


  checkLocationPermission() async {
    // 받을 때 까지 대기하기위해 async 사용
    // 권한 다이어로그 띄우기를 permission에 저장
    LocationPermission permission = await Geolocator.checkPermission();
    // 아무것도 누르지 않은 초기상태로 받을 때 까지 대기
    if (permission == LocationPermission.denied) {
      // 값을 받을 때 까지 대기
      permission = await Geolocator.requestPermission();
    }
    // 항상 거부
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    // 앱사용 중 허용 이거나 항상허용
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation(); // 위치 불러오기
    }
  }

Future<void> getCurrentLocation() async {
  try {
    print('실행됨');
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, // 정확도를 best로
      forceAndroidLocationManager: true,
    );
    print('실행됨1');
    print("position: $position");
    currentPostion = position;
    canRun = true; // 화면 다시 그리기
    latData.value = currentPostion!.latitude; // 위도 넣기
    longData.value = currentPostion!.longitude; // 경도 넣기
    print("latData, longData : $latData, $longData");
  } catch (e) {
    print('error $e');
  }
}

  // List<double> calculateDistances() {
  //   List<double> distances = [];

  //   if (myLocation.value == null) {
  //     return distances; // 빈 리스트 반환
  //   } else {
  //     // 내 위도경도
  //     double myLatitude = currentPostion!.latitude;
  //     double myLongitude = currentPostion!.longitude;

  //     // 사용자 2명의 위도경도
  //     for (int i = 0; i < userList.length; i++) {
  //       double userLatitude = userList[i]['ulat'];
  //       double userLongitude = userList[i]['ulng'];

  //       // 위도 경도간의 직선거리
  //       double distanceInMeters = Geolocator.distanceBetween(
  //         myLatitude,
  //         myLongitude,
  //         userLatitude,
  //         userLongitude,
  //       );
  //       // 거리를 리스트에 추가
  //       distances.add(distanceInMeters);
  //     }

  //     return distances;
  //   }
  // }
}
