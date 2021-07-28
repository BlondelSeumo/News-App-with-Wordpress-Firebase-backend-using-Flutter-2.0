import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/components/HtmlWidget.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/models/UserModel.dart';
import 'package:mighty_news_firebase/screens/admin/CommentScreen.dart';
import 'package:mighty_news_firebase/screens/user/AuthorNewsListScreen.dart';
import 'package:mighty_news_firebase/screens/user/LoginScreen.dart';
import 'package:mighty_news_firebase/screens/user/components/BreakingNewsListWidget.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

// ignore: must_be_immutable
class NewsDetailScreen extends StatefulWidget {
  static String tag = '/NewsDetailScreen';
  NewsData? data;
  String? id;

  NewsDetailScreen({this.data, this.id});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  BannerAd? myBanner;
  InterstitialAd? myInterstitial;
  String postContent = '';

  String? authorName = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor(delay: 500);

    if (widget.data != null) {
      setPostContent(widget.data!.content.validate());

      widget.id = widget.data!.id.toString();
    }

    newsService.newsDetail(widget.id).then((value) {
      if (!postViewedList.contains(widget.id)) {
        newsService.updatePostCount(widget.id);

        /// Add to array
        postViewedList.add(widget.id);
        setValue(POST_VIEWED_LIST, jsonEncode(postViewedList));
      }
      widget.data = value;

      setPostContent(value.content);
    }).catchError((e) {
      toast(e.toString());
    });

    if (isMobile && !getBoolAsync(DISABLE_AD)) {
      myBanner = buildBannerAd()..load();

      if (mAdShowCount < 5) {
        mAdShowCount++;
      } else {
        mAdShowCount = 0;
        myInterstitial = buildInterstitialAd()..load();
      }
    }
  }

  Future<void> setPostContent(String? text) async {
    postContent = text
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>');

    setState(() {});
  }

  Future<void> bookmarkNews() async {
    if (appStore.isLoggedIn) {
      if (bookmarkList.contains(widget.data!.id)) {
        removeToBookmark();
      } else {
        addToBookmark();
      }

      await setValue(BOOKMARKS, jsonEncode(bookmarkList));

      toast('save'.translate);
      setState(() {});

      LiveStream().emit(StreamRefreshBookmark, true);
    } else {
      LoginScreen(isNewTask: false).launch(context).then((value) {
        //bookmarkNews();
      });
    }
  }

  Future<void> addToBookmark() async {
    bookmarkList.add(widget.data!.id);

    await userService.updateDocument({UserKeys.bookmarks: bookmarkList}, appStore.userId).then((value) {
      //
    }).catchError((e) {
      bookmarkList.remove(widget.data!.id);
      setState(() {});
    });
  }

  Future<void> removeToBookmark() async {
    bookmarkList.remove(widget.data!.id);

    await userService.updateDocument({UserKeys.bookmarks: bookmarkList}, appStore.userId).then((value) {
      //
    }).catchError((e) {
      bookmarkList.add(widget.data!.id);
      setState(() {});
    });
  }

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
      listener: AdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: AdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(testDevices: adMobTestDevices),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setDynamicStatusBarColor(delay: 500);
    myInterstitial?.show();
    myBanner?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.data != null
          ? appBarWidget(
              widget.data!.title!,
              color: getAppBarWidgetBackGroundColor(),
              textColor: getAppBarWidgetTextColor(),
              actions: [
                IconButton(
                  icon: Icon(bookmarkList.contains(widget.data!.id) ? Icons.bookmark : Icons.bookmark_border, color: colorPrimary),
                  onPressed: () => bookmarkNews(),
                ),
              ],
            )
          : null,
      body: widget.data != null
          ? Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getPostCategoryTagWidget(context, widget.data),
                                Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined, size: 18),
                                    8.width,
                                    Text(widget.data!.postViewCount.toString(), style: secondaryTextStyle()),
                                  ],
                                ),
                              ],
                            ).paddingOnly(top: 4, bottom: 4, left: 8, right: 8),
                            Text(
                              parseHtmlString(widget.data!.title.validate()),
                              style: boldTextStyle(size: 26, fontFamily: titleFont()),
                            ).paddingOnly(left: 8, right: 8),
                            8.height,
                            cachedImage(
                              widget.data!.image.validate(),
                              height: 300,
                              fit: BoxFit.cover,
                              width: context.width(),
                              alignment: Alignment.topCenter,
                            ).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(top: 8, bottom: 8, left: 8, right: 8),
                            FutureBuilder<UserModel>(
                              future: newsService.getAuthor(widget.data!.authorRef!),
                              builder: (_, snap) {
                                if (snap.hasData) {
                                  authorName = snap.data!.name;
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (snap.hasData)
                                          cachedImage(
                                            snap.data!.image.validate(),
                                            height: 45,
                                            fit: BoxFit.cover,
                                            width: 45,
                                          ).cornerRadiusWithClipRRect(25),
                                        8.width,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snap.hasData ? snap.data!.name! : '', style: primaryTextStyle()),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_rounded, color: textSecondaryColorGlobal, size: 16),
                                                4.width,
                                                if (widget.data!.updatedAt != null) Text(widget.data!.createdAt!.timeAgo, style: secondaryTextStyle(size: 12)),
                                                4.width,
                                                Text('・', style: secondaryTextStyle()),
                                                Text('${(parseHtmlString(widget.data!.content).calculateReadTime()).ceilToDouble().toInt()} ${'min_read'.translate}', style: secondaryTextStyle(size: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios_rounded),
                                      onPressed: () {
                                        appStore.setLoading(true);

                                        newsService.newsByAuthor(widget.data!.authorRef).then((value) {
                                          appStore.setLoading(false);

                                          AuthorNewsListScreen(title: '${'news_by'.translate} $authorName', news: value).launch(context);
                                        }).catchError((e) {
                                          appStore.setLoading(false, toastMsg: e.toString());
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).paddingSymmetric(horizontal: 8, vertical: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data!.shortContent.validate(),
                                  style: primaryTextStyle(size: getIntAsync(FONT_SIZE_PREF, defaultValue: 16)),
                                ).paddingOnly(left: 8, right: 8),
                                8.height,
                              ],
                            ).visible(widget.data!.shortContent.validate().isNotEmpty),

                            ///
                            HtmlWidget(postContent: postContent.validate()),

                            16.height,

                            Text('Source Link', style: secondaryTextStyle(color: Colors.blue)).paddingLeft(8).onTap(() {
                              launchUrl(widget.data!.sourceUrl!, forceWebView: true);
                            }).visible(widget.data!.sourceUrl.validate().isNotEmpty),
                            30.height,
                            AppButton(
                              text: 'view_Comments'.translate,
                              textStyle: boldTextStyle(),
                              onTap: () async {
                                await CommentScreen(newsId: widget.data!.id).launch(context);
                              },
                              width: context.width(),
                            ).paddingSymmetric(horizontal: 16),
                          ],
                        ).paddingOnly(top: 8, left: 8, right: 8, bottom: 30),
                        16.height,
                        if (myBanner != null) Container(child: AdWidget(ad: myBanner!), height: myBanner!.size.height.toDouble()),
                        16.height,
                        FutureBuilder<List<NewsData>>(
                          future: newsService.relatedNewsFuture(widget.data!.categoryRef, widget.data!.id),
                          builder: (_, snap) {
                            if (snap.hasData && snap.data!.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('related_news'.translate, style: boldTextStyle()).paddingAll(16),
                                  BreakingNewsListWidget(snap.data),
                                  8.height,
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Observer(builder: (_) => Loader().visible(appStore.isLoading)),
              ],
            )
          : Loader(),
    );
  }
}
