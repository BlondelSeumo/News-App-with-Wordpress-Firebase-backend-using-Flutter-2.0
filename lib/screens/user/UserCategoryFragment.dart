import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/screens/user/ViewAllNewsScreen.dart';
import 'package:mighty_news_firebase/shimmer/TopicShimmer.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class UserCategoryFragment extends StatelessWidget {
  static String tag = '/UserCategoryFragment';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<CategoryData>>(
        future: categoryService.categoriesFuture(),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) return noDataWidget();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Text('categories'.translate, style: boldTextStyle(size: 20)),
                  16.height,
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runSpacing: 12,
                    spacing: 12,
                    children: snap.data!.map((e) {
                      return Container(
                        // padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: 150,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            cachedImage(e.image, height: 100, width: 150, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                            8.height,
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Text(
                                e.name!,
                                style: boldTextStyle(color: Colors.white, size: 12, backgroundColor: Colors.black38),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).fit(),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        ViewAllNewsScreen(title: e.name, filterBy: FilterByCategory, categoryRef: categoryService.ref!.doc(e.id)).launch(context);
                      });
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return snapWidgetHelper(snap, loadingWidget: TopicShimmer());
          }
        },
      ),
    );
  }
}
