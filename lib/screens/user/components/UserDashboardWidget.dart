import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mighty_news_firebase/models/DashboardResponse.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../UserNewsListWidget.dart';
import '../ViewAllNewsScreen.dart';
import 'BreakingNewsListWidget.dart';
import 'BreakingNewsMarqueeWidget.dart';
import 'QuickReadWidget.dart';
import 'StoryListWidget.dart';
import 'ViewAllHeadingWidget.dart';

class UserDashboardWidget extends StatefulWidget {
  final AsyncSnapshot<DashboardResponse> snap;

  UserDashboardWidget(this.snap);

  @override
  UserDashboardWidgetState createState() => UserDashboardWidgetState();
}

class UserDashboardWidgetState extends State<UserDashboardWidget> with SingleTickerProviderStateMixin {
  String mBreakingNewsMarquee = '';

  AsyncMemoizer asyncMemoizer = AsyncMemoizer<List<String>>();
  List<String> json = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mBreakingNewsMarquee = '';

    widget.snap.data!.breakingNews.validate().forEach((element) {
      mBreakingNewsMarquee = mBreakingNewsMarquee + ' | ' + element.title!;
    });

    loadJson();

    LiveStream().on(StreamRefresh, (v) {
      loadJson();
    });
  }

  Future<void> loadJson() async {
    Iterable widgets = sharedPreferences.getStringList(DASHBOARD_WIDGET_ORDER)!;

    if (widgets.isNotEmpty) {
      json.clear();
      json.addAll(widgets.map((e) => e));
    }
    if (json.isEmpty) {
      String defaultOrder = await rootBundle.loadString('assets/dashboard.json');
      Iterable it = jsonDecode(defaultOrder);

      json.clear();
      json.addAll(it.map((e) => e));
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(StreamRefresh);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget breakingNewsWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          20.height,
          ViewAllHeadingWidget(
            title: 'breaking_News'.translate.toUpperCase(),
            onTap: () {
              ViewAllNewsScreen(title: 'breaking_News'.translate, newsType: NewsTypeBreaking).launch(context);
            },
          ),
          8.height,
          BreakingNewsListWidget(widget.snap.data!.breakingNews),
        ],
      ).visible(widget.snap.data!.breakingNews.validate().isNotEmpty);
    }

    Widget recentNewsWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          8.height,
          ViewAllHeadingWidget(
            title: 'recent_News'.translate.toUpperCase(),
            onTap: () {
              ViewAllNewsScreen(title: 'recent_News'.translate, newsType: NewsTypeRecent).launch(context);
            },
          ),
          8.height,
          UserNewsListWidget(list: widget.snap.data!.recentNews.validate()),
        ],
      ).visible(widget.snap.data!.recentNews.validate().isNotEmpty);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: json.map((e) {
        if (e == DashboardWidgetsBreakingNewsMarquee) {
          return BreakingNewsMarqueeWidget(string: mBreakingNewsMarquee);
        } else if (e == DashboardWidgetsStory) {
          return StoryListWidget(list: widget.snap.data!.story);
        } else if (e == DashboardWidgetsBreakingNews) {
          return breakingNewsWidget();
        } else if (e == DashboardWidgetsQuickRead) {
          return QuickReadWidget(widget.snap.data!.recentNews.validate()..addAll(widget.snap.data!.breakingNews!));
        } else if (e == DashboardWidgetsRecentNews) {
          return recentNewsWidget();
        } else {
          return SizedBox();
        }
      }).toList(),
    );
  }
}
