import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentTextWidget extends StatelessWidget {
  static String tag = '/CommentText';
  final int? value;
  final String? text;
  final Color? textColor;

  CommentTextWidget({this.value, this.textColor, this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text.validate(), style: secondaryTextStyle(color: textColor));
  }
}
