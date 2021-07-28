import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/screens/user/UserDashboardScreen.dart';
import 'package:mighty_news_firebase/screens/user/WalkThroughScreen.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

import '../main.dart';
import 'admin/AdminDashboardScreen.dart';
import 'admin/AdminLoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 2.seconds.delay;

    appLocalizations = AppLocalizations.of(context);

    if (!isMobile) {
      /// For Web & MacOS
      if (appStore.isLoggedIn) {
        AdminDashboardScreen().launch(context, isNewTask: true);
      } else {
        AdminLoginScreen().launch(context, isNewTask: true);
      }
    } else {
      /// For Mobile
      ///

      await setBookmarkList();

      if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
        WalkThroughScreen().launch(context, isNewTask: true);
      } else {
        UserDashboardScreen().launch(context, isNewTask: true);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/app_logo.png', height: 120),
              Text(appName, style: boldTextStyle(size: 22)),
            ],
          ),
          Positioned(
            bottom: 16,
            child: isWeb
                ? Text('V ${getStringAsync(FLUTTER_WEB_BUILD_VERSION, defaultValue: '1.0.0')}')
                : FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return Text('V ${snap.data!.version.validate()}', style: secondaryTextStyle()).paddingBottom(8);
                      }
                      return SizedBox();
                    },
                  ),
          ),
        ],
      ).center(),
    );
  }
}
