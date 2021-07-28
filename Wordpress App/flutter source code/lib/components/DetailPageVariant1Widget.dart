import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/CommentListScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';
import 'AppWidgets.dart';
import 'BreakingNewsListWidget.dart';
import 'CommentTextWidget.dart';
import 'HtmlWidget.dart';

class DetailPageVariant1Widget extends StatefulWidget {
  static String tag = '/DetailPageVariant1Widget';

  final NewsData? newsData;
  final int? postView;
  final String? postContent;
  final List<NewsData>? relatedNews;
  final String? heroTag;

  DetailPageVariant1Widget(this.newsData, {this.postView, this.postContent, this.relatedNews, this.heroTag});

  @override
  _DetailPageVariant1WidgetState createState() => _DetailPageVariant1WidgetState();
}

class _DetailPageVariant1WidgetState extends State<DetailPageVariant1Widget> {
  @override
  void initState() {
    super.initState();
    setDynamicStatusBarColorDetail(milliseconds: 400);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos,
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.newsData!.category.validate().isNotEmpty)
                getPostCategoryTagWidget(context, widget.newsData!).withSize(height: 40, width: context.width()).paddingSymmetric(horizontal: 16, vertical: 8),
              8.height,
              Text(parseHtmlString(widget.newsData!.post_title.validate()), style: boldTextStyle(size: 26, fontFamily: titleFont())).paddingOnly(left: 16, right: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesome.commenting_o, size: 16, color: textSecondaryColor),
                      8.width,
                      CommentTextWidget(text: widget.newsData!.no_of_comments_text.validate(value: '0')),
                    ],
                  ).paddingOnly(left: 16, right: 8, top: 8, bottom: 8).onTap(() async {
                    await CommentListScreen(widget.newsData!.iD).launch(context);

                    setDynamicStatusBarColorDetail(milliseconds: 400);
                  }),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesome.eye, size: 16, color: textSecondaryColor),
                      8.width,
                      Text(widget.postView.validate().toString(), style: secondaryTextStyle()),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                ],
              ),
              cachedImage(
                widget.newsData!.full_image.validate(),
                height: 300,
                fit: BoxFit.cover,
                width: context.width(),
                alignment: Alignment.topCenter,
              ).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(top: 8, bottom: 8, left: 16, right: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextIcon(
                    text: '${widget.newsData!.post_author_name.validate()}',
                    textStyle: secondaryTextStyle(),
                    prefix: Icon(Icons.person_outline_rounded),
                  ).visible(widget.newsData!.post_author_name.validate().isNotEmpty).expand(),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, color: textSecondaryColorGlobal, size: 16),
                      4.width,
                      Text(widget.newsData!.human_time_diff.validate(), style: secondaryTextStyle()),
                      4.width,
                      Text('・', style: secondaryTextStyle()),
                      Text(getArticleReadTime(context, widget.newsData!.post_content.validate()), style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 8),
              HtmlWidget(postContent: widget.postContent).paddingOnly(left: 8, right: 8),
              30.height,
              AppButton(
                text: appLocalization.translate('view_Comments'),
                color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                textStyle: boldTextStyle(color: white),
                onTap: () async {
                  await CommentListScreen(widget.newsData!.iD).launch(context);

                  setDynamicStatusBarColorDetail(milliseconds: 400);
                },
                width: context.width(),
              ).paddingSymmetric(horizontal: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    margin: EdgeInsets.only(left: 16, top: 32, bottom: 8),
                    decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(defaultRadius)),
                    child: Text(appLocalization.translate('related_news'), style: boldTextStyle(size: 12, color: Colors.white, letterSpacing: 1.5)),
                  ),
                  BreakingNewsListWidget(widget.relatedNews.validate()),
                ],
              ).visible(widget.relatedNews.validate().isNotEmpty),
            ],
          ),
        ),
      ),
    );
  }
}
