import 'package:get/get.dart';
import 'package:test_twilio/bindings/controller_dependencies.dart';
import 'package:test_twilio/bindings/network_dependencies.dart';
import 'package:test_twilio/bindings/repository_dependencies.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';

/// AppBindings
class AppBindings extends Bindings {
  @override
  void dependencies() {
    injectNetworkDependencies();
    injectRepositories();
    injectControllers();
    BasicChatChannel().initMethodChannel(Get.find());
  }
}
