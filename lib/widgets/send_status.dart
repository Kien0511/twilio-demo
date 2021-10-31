import 'package:flutter/material.dart';

class SendStatus extends StatelessWidget {
  final int? status;


  SendStatus(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: status == 1 ? _buildSending() : status == 2 ? _buildSent() : status == 3 ? _buildError() : SizedBox(),
    );
  }

  Widget _buildSending() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey
      ),
      child: Icon(Icons.more_horiz, color: Colors.white, size: 12.0,),
    );
  }

  Widget _buildSent() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey
      ),
      child: Icon(Icons.check, color: Colors.white, size: 12.0,),
    );
  }

  Widget _buildError() {
    return Container(
      child: Icon(Icons.error, color: Colors.red[700], size: 12.0,),
    );
  }
}