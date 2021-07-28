import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/screens/admin/components/NewCategoryDialog.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../../main.dart';
import 'components/CategoryItemWidget.dart';

class CategoryListScreen extends StatefulWidget {
  static String tag = '/CategoryListScreen';

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
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
    appLocalizations = AppLocalizations.of(context);

    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('categories'.translate, style: boldTextStyle()),
                AppButton(
                  text: 'add_category'.translate,
                  onTap: () {
                    showInDialog(context, child: NewCategoryDialog());
                  },
                ),
              ],
            ),
            8.height,
            StreamBuilder<List<CategoryData>>(
              stream: categoryService.categories(),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.isEmpty) return noDataWidget();

                  return Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 16,
                    runSpacing: 8,
                    children: snap.data.validate().map((e) {
                      return CategoryItemWidget(data: e);
                    }).toList(),
                  );
                } else {
                  return snapWidgetHelper(snap);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
