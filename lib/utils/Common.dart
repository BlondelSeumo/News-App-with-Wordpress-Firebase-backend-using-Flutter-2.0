import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'Constants.dart';

extension SExt on String {
  String get translate => appLocalizations!.translate(this);
}

String? titleFont() {
  return GoogleFonts.cormorantGaramond().fontFamily;
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String parseDocumentDate(DateTime dateTime, [bool includeTime = false]) {
  if (includeTime) {
    return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
  } else {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}

InputDecoration inputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    alignLabelWithHint: true,
  );
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launch(url, forceWebView: forceWebView, enableJavaScript: true).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

double newsListWidgetSize(BuildContext context) => isWeb ? 300 : context.width() * 0.6;

bool isLoggedInWithGoogle() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeGoogle;
}

bool isLoggedInWithApp() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeApp;
}

bool isLoggedInWithApple() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeApple;
}

bool isLoggedInWithOTP() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeOTP;
}

String storeBaseURL() {
  return isAndroid ? playStoreBaseURL : appStoreBaseUrl;
}

void setDynamicStatusBarColor({int delay = 200}) {
  if (appStore.isDarkMode) {
    //setStatusBarColor(scaffoldSecondaryDark, delayInMilliSeconds: delay);
  } else {
    //setStatusBarColor(Colors.white, delayInMilliSeconds: delay);
  }
}

Color getAppBarWidgetBackGroundColor() {
  return appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white;
}

Color getAppBarWidgetTextColor() {
  return appStore.isDarkMode ? white : black;
}

void setTheme() {
  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);

  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }
}

void setPostViewsList() {
  String s = getStringAsync(POST_VIEWED_LIST);

  if (s.isNotEmpty) {
    Iterable it = jsonDecode(s);

    postViewedList.clear();
    postViewedList.addAll(it.map((e) => e.toString()).toList());
  }
}

List<LanguageDataModel>? languageList() {
  List<LanguageDataModel> list = [];

  list.add(LanguageDataModel(id: 0, name: 'English', languageCode: 'en', flag: 'assets/flags/ic_us.png', fullLanguageCode: 'en-EN'));
  list.add(LanguageDataModel(id: 1, name: 'हिंदी', languageCode: 'hi', flag: 'assets/flags/ic_india.png', fullLanguageCode: 'hi-IN'));
  list.add(LanguageDataModel(id: 2, name: 'français', languageCode: 'fr', flag: 'assets/flags/ic_french.png', fullLanguageCode: 'fr-FR'));
  list.add(LanguageDataModel(id: 3, name: 'عربى', languageCode: 'ar', flag: 'assets/flags/ic_ar.png', fullLanguageCode: 'ar-AR'));

  return list;
}
