import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController inputTextController = TextEditingController();
  final String? message;
  final Function(String)? onUpdate;
  final String titleAction;

  CustomInputTextField({required this.message, this.onUpdate, this.titleAction = "Update"}) {
    inputTextController.text = this.message!;
  }

  @override
  Widget build(BuildContext context) {;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                color: Colors.white,
                child: TextField(
                controller: inputTextController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: 'input',
                    suffixStyle: const TextStyle(color: Colors.green)),
            ),
              ),
                SizedBox(height: 24.0,),
                Material(
                  child: InkWell(
                    onTap: () {
                      if (inputTextController.text.trim().isNotEmpty) {
                        onUpdate?.call(inputTextController.text.toString());
                      }
                    },
                    child: Container(
                      height: 56.0,
                      child: Center(child: Text(titleAction)),
                    ),
                  ),
                ),
                SizedBox(height: 8.0,),
                Material(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 56.0,
                      child: Center(child: Text("Cancel")),
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
}