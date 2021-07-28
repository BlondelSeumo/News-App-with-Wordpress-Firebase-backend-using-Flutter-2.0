import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/components/LanguageSelectionWidget.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/screens/admin/AdminLoginScreen.dart';
import 'package:mighty_news_firebase/screens/admin/components/AdminStatisticsWidget.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'components/DrawerWidget.dart';

class AdminDashboardScreen extends StatefulWidget {
  static String tag = '/AdminDashboardScreen';

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Widget currentWidget = AdminStatisticsWidget();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    LiveStream().on(StreamUpdateDrawer, (index) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(StreamUpdateDrawer);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/app_logo.png', height: 40),
            16.width,
            Text(appName, style: boldTextStyle(color: colorPrimary)),
          ],
        ),
        actions: [
          LanguageSelectionWidget(showTitle: false).withWidth(180),
          Row(
            children: [
              appStore.userProfileImage!.isNotEmpty
                  ? cachedImage(appStore.userProfileImage, width: 34, height: 34, fit: BoxFit.cover).cornerRadiusWithClipRRect(20)
                  : Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorPrimary.withOpacity(0.2)),
                      child: Text(appStore.userFullName!.split('').first, style: boldTextStyle(size: 14)),
                    ),
              16.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appStore.userFullName!, style: primaryTextStyle(size: 12)),
                  Text(appStore.userEmail!, style: primaryTextStyle(size: 10)),
                ],
              ),
            ],
          ),
          16.width,
          Text('logout'.translate, style: boldTextStyle(color: colorPrimary)).paddingAll(8).onTap(() {
            showConfirmDialogCustom(
              context,
              title: 'logout_confirmation'.translate,
              positiveText: 'yes'.translate,
              negativeText: 'no'.translate,
              onAccept: () {
                logout(context, onLogout: () {
                  AdminLoginScreen().launch(context, isNewTask: true);
                });
              },
            );
          }).center(),
          16.width,
        ],
      ),
      body: Container(
        height: context.height(),
        child: Row(
          children: [
            Container(
              width: 240,
              color: Colors.white,
              height: context.height(),
              child: DrawerWidget(
                onWidgetSelected: (w) {
                  currentWidget = w;

                  setState(() {});
                },
              ),
            ),
            Container(
              width: context.width() - 240,
              height: context.height(),
              child: currentWidget,
            ),
          ],
        ),
      ),
    );
  }
}
