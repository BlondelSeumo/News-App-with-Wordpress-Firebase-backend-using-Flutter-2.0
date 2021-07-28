import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllHeadingWidget extends StatelessWidget {
  static String tag = '/ViewAllHeadingWidget';
  final String? title;
  final Color? backgroundColor;
  final Color? textColor;
  final Function? onTap;

  ViewAllHeadingWidget({this.title, this.onTap, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          margin: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: backgroundColor ?? colorPrimary.withOpacity(0.2),
            borderRadius: radius(defaultRadius),
            border: Border.all(color: colorPrimary),
          ),
          child: Text(title.validate(), style: boldTextStyle(size: 12, color: textColor ?? colorPrimary, letterSpacing: 1.5)),
        ),
        Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(),
          child: Text(
            'view_all'.translate,
            style: boldTextStyle(size: 12),
          ).paddingAll(8).onTap(() => onTap?.call()).visible(onTap != null),
        ),
      ],
    );
  }
}
