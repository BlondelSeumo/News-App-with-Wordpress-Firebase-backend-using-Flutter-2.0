import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/Marquee2Custom.dart' as m;
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class BreakingNewsMarqueeWidget extends StatefulWidget {
  static String tag = '/BreakingNewsMarqueeWidget';
  final String? string;

  BreakingNewsMarqueeWidget({this.string});

  @override
  BreakingNewsMarqueeWidgetState createState() => BreakingNewsMarqueeWidgetState();
}

class BreakingNewsMarqueeWidgetState extends State<BreakingNewsMarqueeWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (getBoolAsync(DISABLE_HEADLINE_WIDGET)) return SizedBox();
    if (widget.string.validate().isEmpty) return SizedBox();

    return Container(
      height: 45.0,
      width: context.width(),
      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkMode ? black : white),
      child: m.Marquee(
        child: Text(widget.string.validate(), style: boldTextStyle()),
        style: primaryTextStyle(),
      ),
    );
  }
}
