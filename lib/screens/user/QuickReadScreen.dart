import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/screens/user/NewsDetailScreen.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

// ignore: must_be_immutable
class QuickReadScreen extends StatefulWidget {
  static String tag = '/QuickReadScreen';
  List<NewsData> news;

  QuickReadScreen({required this.news});

  @override
  _QuickReadScreenState createState() => _QuickReadScreenState();
}

class _QuickReadScreenState extends State<QuickReadScreen> {
  PageController pageController = PageController();

  int page = 1;
  int numPage = 1;

  bool hasError = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    init();

    loadNews();
  }

  Future<void> init() async {
    pageController.addListener(() {
      if ((pageController.page!.toInt() + 1) == widget.news.length) {
        if (page < numPage) {
          page++;

          appStore.setLoading(true);
          loadNews();
        }
      }
    });
  }

  Future<void> loadNews() async {
    //
  }

  Future<void> bookmarkNews(NewsData data) async {
    if (appStore.isLoggedIn) {
      if (bookmarkList.contains(data.id)) {
        removeToBookmark(data);
      } else {
        addToBookmark(data);
      }

      toast('save'.translate);
      setState(() {});
    } else {
      //
    }
  }

  Future<void> addToBookmark(NewsData data) async {
    bookmarkList.add(data.id);
    await setValue(BOOKMARKS, jsonEncode(bookmarkList));

    await userService.updateDocument({UserKeys.bookmarks: bookmarkList}, appStore.userId);
  }

  Future<void> removeToBookmark(NewsData data) async {
    bookmarkList.remove(data.id);
    await setValue(BOOKMARKS, jsonEncode(bookmarkList));

    await userService.updateDocument({UserKeys.bookmarks: bookmarkList}, appStore.userId);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
              ),
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: widget.news.validate().map((e) {
                  return GestureDetector(
                    onHorizontalDragEnd: (v) {
                      if (v.velocity.pixelsPerSecond.dx.isNegative) {
                        NewsDetailScreen(data: e).launch(context);
                      }
                    },
                    child: Container(
                      child: Column(
                        children: [
                          cachedImage(e.image, width: context.width(), fit: BoxFit.cover),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parseHtmlString(e.title.validate()),
                                style: boldTextStyle(size: 20, color: bookmarkList.contains(e.id) ? colorPrimary : textPrimaryColorGlobal),
                                maxLines: 4,
                              ).onTap(() {
                                bookmarkNews(e);
                              }),
                              8.height,
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16),
                                  4.width,
                                  if (e.createdAt != null) Text(e.createdAt!.timeAgo, style: secondaryTextStyle()),
                                  4.width,
                                  Text('・', style: secondaryTextStyle()),
                                  4.width,
                                  Text(
                                    '${(parseHtmlString(e.content).calculateReadTime()).ceilToDouble().toInt()} ${'min_read'.translate}',
                                    style: secondaryTextStyle(size: 12),
                                  ),
                                ],
                              ),
                              8.height,
                              Text(parseHtmlString(e.shortContent.validate()), style: primaryTextStyle()).expand(),
                              Text('read_more'.translate, style: boldTextStyle(color: colorPrimary)).paddingAll(8),
                            ],
                          ).paddingSymmetric(horizontal: 16).expand(),
                        ],
                      ),
                    ).onTap(() {
                      NewsDetailScreen(data: e).launch(context);
                    }),
                  );
                }).toList(),
              ),
            ),
            if (hasError) Text(error.validate()).center(),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
