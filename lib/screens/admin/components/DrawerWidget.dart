import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/models/ListModel.dart';
import 'package:mighty_news_firebase/screens/admin/AdminSettingScreen.dart';
import 'package:mighty_news_firebase/screens/admin/components/AllNewsListWidget.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../CategoryListScreen.dart';
import '../UploadNewsScreen.dart';
import '../UserListScreen.dart';
import 'AdminStatisticsWidget.dart';
import 'IndependentNewsGridWidget.dart';
import 'SendNotificationWidget.dart';

class DrawerWidget extends StatefulWidget {
  static String tag = '/DrawerWidget';
  final Function(Widget) onWidgetSelected;

  DrawerWidget({required this.onWidgetSelected});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<ListModel> list = [];

  int index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    updateItem();

    LiveStream().on(StreamSelectItem, (index) {
      this.index = index as int;

      widget.onWidgetSelected.call(list[index].widget!);

      setState(() {});
    });
    LiveStream().on(StreamUpdateDrawer, (index) {
      updateItem();
    });
  }

  void updateItem() {
    list.clear();

    list.add(ListModel(name: 'dashboard'.translate, widget: AdminStatisticsWidget(), leading: Icon(AntDesign.dashboard)));
    list.add(ListModel(name: 'upload_news'.translate, widget: UploadNewsScreen(), leading: Icon(Feather.upload_cloud)));
    list.add(ListModel(name: 'all_news'.translate, widget: AllNewsListWidget(), leading: Icon(FontAwesome.newspaper_o)));
    list.add(ListModel(name: 'recent_News'.translate, widget: IndependentNewsGridWidget(newsType: NewsTypeRecent), leading: Icon(FontAwesome.newspaper_o)));
    list.add(ListModel(name: 'breaking_News'.translate, widget: IndependentNewsGridWidget(newsType: NewsTypeBreaking), leading: Icon(FontAwesome.newspaper_o)));
    list.add(ListModel(name: 'top_stories'.translate, widget: IndependentNewsGridWidget(newsType: NewsTypeStory), leading: Icon(FontAwesome.newspaper_o)));
    list.add(ListModel(name: 'news_categories'.translate, widget: CategoryListScreen(), leading: Image.asset('assets/ic_category.png', height: 24)));
    list.add(ListModel(name: 'notifications'.translate, widget: SendNotificationWidget(), leading: Icon(AntDesign.bells)));
    list.add(ListModel(name: 'manage_user'.translate, widget: UserListScreen(), leading: Icon(Feather.users)));
    list.add(ListModel(name: 'settings'.translate, widget: AdminSettingScreen(), leading: Icon(Feather.settings)));

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(StreamUpdateDrawer);
    LiveStream().dispose(StreamSelectItem);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Wrap(
          children: list.map((e) {
            int cIndex = list.indexOf(e);

            return SettingItemWidget(
              title: e.name!,
              leading: e.leading,
              titleTextColor: cIndex == index ? colorPrimary : null,
              decoration: BoxDecoration(
                color: cIndex == index ? colorPrimary.withOpacity(0.1) : null,
                borderRadius: radiusOnly(bottomRight: 30, topRight: 30),
              ),
              onTap: () {
                index = list.indexOf(e);

                widget.onWidgetSelected.call(e.widget!);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
