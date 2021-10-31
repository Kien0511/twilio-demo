import 'package:flutter/material.dart';

class EmojiText extends StatelessWidget {

  const EmojiText({
    Key? key,
    required this.text,
    required this.count,
  }) : super(key: key);

  final String text;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4.0),
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white
      ),
      child: Row(
        children: [
          Text(text),
          SizedBox(width: 2.0,),
          Text("$count")
        ],
      ),
    );
  }

}