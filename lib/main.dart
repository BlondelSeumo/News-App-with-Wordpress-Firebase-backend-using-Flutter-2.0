import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_news_firebase/screens/SplashScreen.dart';
import 'package:mighty_news_firebase/services/AppSettingService.dart';
import 'package:mighty_news_firebase/services/CategoryService.dart';
import 'package:mighty_news_firebase/services/NewsService.dart';
import 'package:mighty_news_firebase/services/UserService.dart';
import 'package:mighty_news_firebase/store/AppStore.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'AppLocalizations.dart';
import 'AppTheme.dart';
import 'models/FontSizeModel.dart';
import 'models/WeatherResponse.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

LanguageDataModel? language;
//List<Language> languages = Language.getLanguages();

FontSizeModel? fontSize;
List<FontSizeModel> fontSizes = FontSizeModel.fontSizes();

NewsService newsService = NewsService();
CategoryService categoryService = CategoryService();
UserService userService = UserService();
AppSettingService appSettingService = AppSettingService();

AppLocalizations? appLocalizations;

var weatherMemoizer = AsyncMemoizer<WeatherResponse>();

List<String?> bookmarkList = [];
List<String?> postViewedList = [];

int mAdShowCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultAppBarElevation = 2.0;

  desktopBreakpointGlobal = 700.0;

  defaultAppButtonTextColorGlobal = colorPrimary;
  appButtonBackgroundColorGlobal = colorPrimary;

  await initialize(
    aLocaleLanguageList: [
      LanguageDataModel(id: 0, name: 'English', languageCode: 'en', flag: 'assets/flags/ic_us.png', fullLanguageCode: 'en-EN'),
      LanguageDataModel(id: 1, name: 'हिंदी', languageCode: 'hi', flag: 'assets/flags/ic_india.png', fullLanguageCode: 'hi-IN'),
      LanguageDataModel(id: 2, name: 'français', languageCode: 'fr', flag: 'assets/flags/ic_french.png', fullLanguageCode: 'fr-FR'),
      LanguageDataModel(id: 3, name: 'عربى', languageCode: 'ar', flag: 'assets/flags/ic_ar.png', fullLanguageCode: 'ar-AR'),
    ],
  );

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: DefaultLanguage));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setAdmin(getBoolAsync(IS_ADMIN));
    appStore.setTester(getBoolAsync(IS_TESTER));
    appStore.setFullName(getStringAsync(FULL_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
  }

  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));

  setTheme();
  setPostViewsList();

  if (isMobile || isWeb) {
    await Firebase.initializeApp();

    if (isMobile) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      MobileAds.instance.initialize();

      await OneSignal.shared.setAppId(mOneSignalAppId);

      //OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

      OneSignal.shared.getDeviceState().then((value) {
        if (value!.userId != null) setValue(PLAYER_ID, value.userId.validate());
      });
    }
  }

  setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        home: SplashScreen(),
      ),
    );
  }
}
