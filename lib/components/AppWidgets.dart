import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      filterQuality: FilterQuality.high,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget noDataWidget() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('assets/no_data.png', height: 80, fit: BoxFit.fitHeight),
      8.height,
      Text('no_data'.translate, style: boldTextStyle()).center(),
    ],
  ).center();
}

Widget getPostCategoryTagWidget(BuildContext context, NewsData? newsData) {
  if (newsData != null && newsData.categoryRef != null) {
    return Container(
      child: Row(
        children: [
          FutureBuilder<CategoryData>(
            future: newsService.getNewsCategory(newsData.categoryRef!),
            builder: (_, snap) {
              if (snap.hasData) {
                return Container(
                  padding: EdgeInsets.only(right: 8, top: 4, bottom: 4, left: 8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(color: colorPrimary, borderRadius: radius()),
                  child: Text(snap.data!.name!, style: boldTextStyle(size: 12, color: Colors.white)),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  } else {
    return Offstage();
  }
}

Widget titleWidget(String title) {
  return Row(
    children: [
      VerticalDivider(color: colorPrimary, thickness: 4).withHeight(10),
      8.width,
      Text(title, style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
    ],
  ).paddingLeft(16);
}
