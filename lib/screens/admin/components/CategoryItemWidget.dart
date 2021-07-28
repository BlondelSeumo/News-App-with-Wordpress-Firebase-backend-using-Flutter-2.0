import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/screens/admin/components/NewCategoryDialog.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import 'IndependentNewsGridWidget.dart';

class CategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final CategoryData? data;

  CategoryItemWidget({this.data});

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
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
    return Container(
      height: 150,
      width: 150,
      child: Stack(
        children: [
          cachedImage(widget.data!.image, height: 200, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          8.height,
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(widget.data!.name!, style: boldTextStyle(color: Colors.white)).fit(),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                if (appStore.isTester) return toast(mTesterNotAllowedMsg);

                showInDialog(context, child: NewCategoryDialog(categoryData: widget.data)).then((value) {
                  //
                });
              },
            ),
          ),
        ],
      ),
    ).onTap(() {
      IndependentNewsGridWidget(showAppBar: true, filterBy: FilterByCategory, categoryRef: categoryService.ref!.doc(widget.data!.id)).launch(context);
    });
  }
}
