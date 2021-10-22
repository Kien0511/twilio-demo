import 'package:get/get.dart';
import 'package:test_twilio/network/app_client.dart';
import 'package:test_twilio/network/network_info.dart';

///injectNetworkDependencies
void injectNetworkDependencies() {
  Get.put(NetworkInfo());
  Get.put(AppClient());
}
