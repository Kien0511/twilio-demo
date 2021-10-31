import 'package:get/get.dart';
import 'package:test_twilio/bindings/controller_dependencies.dart';
import 'package:test_twilio/bindings/network_dependencies.dart';
import 'package:test_twilio/bindings/repository_dependencies.dart';
import 'package:test_twilio/data/database_helper.dart';
import 'package:test_twilio/services/basic_conversation_channel.dart';

/// AppBindings
class AppBindings extends Bindings {
  @override
  void dependencies() {
    DatabaseHelper().initDataBase();
    injectNetworkDependencies();
    injectRepositories();
    injectControllers();
    BasicConversationsChannel().initMethodChannel(Get.find());
  }
}
