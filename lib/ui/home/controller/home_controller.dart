import 'package:get/get.dart';
import 'package:test_twilio/ui/home/conversations/conversations_screen.dart';
import 'package:test_twilio/ui/home/my_page/my_page_screen.dart';

class HomeController extends GetxController {
  final listWidget = [
    ConversationsScreen(),
    MyPageScreen()
  ];

  RxInt currentSelectIndex = RxInt(0);

  void onItemTapped(int index) {
    currentSelectIndex.value = index;
  }
}