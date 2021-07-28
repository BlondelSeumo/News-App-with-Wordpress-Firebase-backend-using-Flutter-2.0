import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/screens/user/BookmarkNewsScreen.dart';
import 'package:mighty_news_firebase/screens/user/HomeFragment.dart';
import 'package:mighty_news_firebase/screens/user/ProfileFragment.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../main.dart';
import 'LoginScreen.dart';
import 'NewsDetailScreen.dart';
import 'SearchFragment.dart';
import 'UserCategoryFragment.dart';

class UserDashboardScreen extends StatefulWidget {
  static String tag = '/UserDashboardScreen';

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> with AfterLayoutMixin<UserDashboardScreen> {
  List<Widget> widgets = [];
  int currentIndex = 0;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    widgets.add(HomeFragment());
    widgets.add(BookmarkNewsScreen());
    widgets.add(UserCategoryFragment());
    widgets.add(SearchFragment());
    widgets.add(ProfileFragment());

    setState(() {});

    await Future.delayed(Duration(milliseconds: 400));

    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    }
    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
    };

    appSettingService.setAppSettings();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (isMobile) {
      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) {
        String? notId = notification.notification.additionalData!["id"];

        if (notId.validate().isNotEmpty) {
          NewsDetailScreen(id: notId.toString()).launch(context);
        }
      });
    }
    appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: DefaultLanguage), context: context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (currentIndex != 0) {
            currentIndex = 0;
            setState(() {});

            return Future.value(false);
          } else {
            DateTime now = DateTime.now();

            if (currentBackPressTime == null || now.difference(currentBackPressTime!) > 2.seconds) {
              currentBackPressTime = now;
              toast('exit_app'.translate);
              return Future.value(false);
            }

            return Future.value(true);
          }
        },
        child: Scaffold(
          body: Container(child: widgets[currentIndex]),
          bottomNavigationBar: Observer(
            builder: (_) => BottomNavigationBar(
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(AntDesign.home, color: context.theme.iconTheme.color),
                  label: 'home'.translate,
                  activeIcon: Icon(AntDesign.home, color: colorPrimary),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesome.bookmark_o, color: context.theme.iconTheme.color),
                  label: 'suggest_for_you'.translate,
                  activeIcon: Icon(FontAwesome.bookmark_o, color: colorPrimary),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category_outlined, color: context.theme.iconTheme.color),
                  label: 'category'.translate,
                  activeIcon: Icon(Icons.category_outlined, color: colorPrimary),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.ios_search, color: context.theme.iconTheme.color),
                  label: 'search_news'.translate,
                  activeIcon: Icon(Ionicons.ios_search, color: colorPrimary),
                ),
                BottomNavigationBarItem(
                  icon: appStore.isLoggedIn && getStringAsync(PROFILE_IMAGE).isNotEmpty
                      ? cachedImage(getStringAsync(PROFILE_IMAGE), height: 24, width: 24, fit: BoxFit.cover).cornerRadiusWithClipRRect(15)
                      : Icon(MaterialIcons.person_outline, color: context.theme.iconTheme.color),
                  label: 'Profile',
                  activeIcon: appStore.isLoggedIn && getStringAsync(PROFILE_IMAGE).isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(border: Border.all(color: colorPrimary), shape: BoxShape.circle),
                          child: cachedImage(getStringAsync(PROFILE_IMAGE), height: 24, width: 24, fit: BoxFit.cover).cornerRadiusWithClipRRect(15))
                      : Icon(MaterialIcons.person_outline, color: colorPrimary),
                ),
              ],
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              onTap: (i) async {
                if (i == 1) {
                  if (!appStore.isLoggedIn) {
                    LoginScreen().launch(context);
                  } else {
                    currentIndex = i;
                  }
                } else {
                  currentIndex = i;
                }

                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
