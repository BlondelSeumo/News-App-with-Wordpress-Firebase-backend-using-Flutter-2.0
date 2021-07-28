import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/components/LanguageSelectionWidget.dart';
import 'package:mighty_news_firebase/components/SocialLoginWidget.dart';
import 'package:mighty_news_firebase/components/ThemeSelectionDialog.dart';
import 'package:mighty_news_firebase/models/FontSizeModel.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import '../../main.dart';
import 'AboutAppScreen.dart';
import 'BookmarkNewsScreen.dart';
import 'ChangePasswordScreen.dart';
import 'EditProfileScreen.dart';
import 'LoginScreen.dart';
import 'UserDashboardScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    200.milliseconds.delay.then((value) => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);

    return Observer(
      builder: (_) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: context.statusBarHeight),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
                      child: appStore.isLoggedIn
                          ? Row(
                              children: [
                                appStore.userProfileImage.validate().isEmpty
                                    ? Icon(Icons.person_outline, size: 40)
                                    : cachedImage(appStore.userProfileImage.validate(), usePlaceholderIfUrlEmpty: true, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appStore.userFullName.validate(), style: boldTextStyle()),
                                    Text(appStore.userEmail.validate(), style: primaryTextStyle()).fit(),
                                  ],
                                ).expand(),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => EditProfileScreen().launch(context),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                                  child: Text('login'.translate, style: boldTextStyle()),
                                ).onTap(() async {
                                  await LoginScreen(isNewTask: false).launch(context);
                                  setState(() {});
                                }),
                                SocialLoginWidget(voidCallback: () => setState(() {})),
                              ],
                            ),
                    ),
                    Divider(height: 20, color: appStore.isDarkMode ? Colors.transparent : Theme.of(context).dividerColor),
                    8.height,
                    titleWidget('app_settings'.translate),
                    LanguageSelectionWidget(),
                    SettingItemWidget(
                      leading: Icon(MaterialCommunityIcons.theme_light_dark),
                      title: '${'select_theme'.translate}',
                      subTitle: 'choose_app_theme'.translate,
                      onTap: () async {
                        await showInDialog(
                          context,
                          child: ThemeSelectionDialog(),
                          contentPadding: EdgeInsets.zero,
                          title: Text('select_theme'.translate, style: boldTextStyle(size: 20)),
                        );
                        if (isIos) {
                          UserDashboardScreen().launch(context, isNewTask: true);
                        }
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(appStore.isNotificationOn ? Feather.bell : Feather.bell_off),
                      title: '${appStore.isNotificationOn ? 'disable'.translate : 'enable'.translate} ${'push_notification'.translate}',
                      subTitle: 'enable_push_notification'.translate,
                      trailing: CupertinoSwitch(
                        activeColor: colorPrimary,
                        value: appStore.isNotificationOn,
                        onChanged: (v) {
                          if (appStore.isLoggedIn) {
                            userService.updateDocument({UserKeys.isNotificationOn: v}, appStore.userId);
                          }

                          appStore.setNotification(v);
                        },
                      ).withHeight(10),
                      onTap: () {
                        appStore.setNotification(!getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));

                        if (appStore.isLoggedIn) {
                          userService.updateDocument({UserKeys.isNotificationOn: appStore.isNotificationOn}, appStore.userId);
                        }
                      },
                    ),
                    SettingItemWidget(
                      leading: Icon(FontAwesome.font),
                      title: 'article_font_size'.translate,
                      subTitle: 'choose_article_size'.translate,
                      trailing: DropdownButton<FontSizeModel>(
                        items: fontSizes.map((e) {
                          return DropdownMenuItem<FontSizeModel>(child: Text('${e.title}', style: primaryTextStyle(size: 14)), value: e);
                        }).toList(),
                        dropdownColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
                        value: fontSize,
                        underline: SizedBox(),
                        onChanged: (FontSizeModel? v) async {
                          hideKeyboard(context);

                          await setValue(FONT_SIZE_PREF, v!.fontSize);

                          fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));

                          setState(() {});
                        },
                      ),
                      onTap: () {
                        //
                      },
                    ),
                    8.height,
                    titleWidget('other'.translate),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.lock_outline_rounded),
                      title: 'change_Pwd'.translate,
                      onTap: () {
                        ChangePasswordScreen().launch(context);
                      },
                    ).visible(appStore.isLoggedIn && isLoggedInWithApp()),
                    8.height.visible(appStore.isLoggedIn && isLoggedInWithApp()),
                    SettingItemWidget(
                      leading: Icon(FontAwesome.bookmark_o),
                      title: 'bookmarks'.translate,
                      onTap: () {
                        if (appStore.isLoggedIn) {
                          BookmarkNewsScreen().launch(context);
                        } else {
                          LoginScreen().launch(context);
                        }
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.share_outlined),
                      title: '${'share'.translate} ${'app_name'.translate}',
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          String package = '';
                          if (isAndroid) package = value.packageName;

                          Share.share('${'share'.translate} $mAppName\n\n${storeBaseURL()}$package');
                        });
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.rate_review_outlined),
                      title: 'rate_us'.translate,
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          String package = '';
                          if (isAndroid) package = value.packageName;

                          launchUrl('${storeBaseURL()}$package');
                        });
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.assignment_outlined),
                      title: 'term_condition'.translate,
                      onTap: () {
                        launchUrl(getStringAsync(TERMS_AND_CONDITION_PREF), forceWebView: true);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.assignment_outlined),
                      title: 'privacyPolicy'.translate,
                      onTap: () {
                        launchUrl(getStringAsync(PRIVACY_POLICY_PREF), forceWebView: true);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.support_rounded),
                      title: 'help_Support'.translate,
                      onTap: () {
                        launchUrl(supportURL, forceWebView: true);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.info_outline),
                      title: 'about'.translate,
                      onTap: () {
                        AboutAppScreen().launch(context);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.exit_to_app_rounded),
                      title: 'logout'.translate,
                      onTap: () async {
                        showConfirmDialogCustom(
                          context,
                          title: 'logout_confirmation'.translate,
                          positiveText: 'yes'.translate,
                          negativeText: 'no'.translate,
                          onAccept: () {
                            logout(context, onLogout: () {
                              UserDashboardScreen().launch(context, isNewTask: true);
                            });
                          },
                        );
                      },
                    ).visible(appStore.isLoggedIn),
                    8.height,
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snap) {
                        if (snap.hasData) {
                          return Text('${'version'.translate} ${snap.data!.version.validate()}', style: secondaryTextStyle(size: 10)).paddingLeft(16);
                        }
                        return SizedBox();
                      },
                    ),
                    20.height,
                  ],
                ),
              ),
              Loader().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
