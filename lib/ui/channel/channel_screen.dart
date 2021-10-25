import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/ui/channel/controller/channel_controller.dart';

class ChannelScreen extends GetView<ChannelController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Channel"),),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => Column(
                children: List.generate(controller.listChannel.value.length, (index) {
                  final channel = controller.listChannel.value.values.toList()[index];
                  return InkWell(
                    onTap: () {
                      controller.checkJoinChannel(channel);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: Get.width,
                      height: 56.0,
                      color: channel.type == 0 ? Colors.blue : Colors.greenAccent,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      child: Text("${channel.friendlyName}"),
                    ),
                  );
                }),
              ),
              ),
              InkWell(
                onTap: () {
                  controller.createChannel();
                },
                child: Container(
                  width: Get.width,
                  height: 56.0,
                  color: Colors.red,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("create channel")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}