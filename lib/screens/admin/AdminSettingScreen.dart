import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/AppSettingModel.dart';
import 'package:mighty_news_firebase/screens/admin/AppDashboardConfigScreen.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';

class AdminSettingScreen extends StatefulWidget {
  static String tag = '/AdminSettingScreen';

  @override
  _AdminSettingScreenState createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  TextEditingController termConditionCont = TextEditingController();
  TextEditingController privacyPolicyCont = TextEditingController();
  TextEditingController contactInfoCont = TextEditingController();
  TextEditingController flutterWebBuildVersionCont = TextEditingController();

  bool? disableAd = false;
  bool? disableLocation = false;
  bool? disableHeadline = false;
  bool? disableQuickRead = false;
  bool? disableStory = false;

  String termCondition = '';
  String privacyPolicy = '';
  String contactInfo = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    appStore.setLoading(true);

    await appSettingService.getAppSettings().then((value) async {
      disableAd = value.disableAd;
      disableLocation = value.disableLocation;
      disableHeadline = value.disableHeadline;
      disableQuickRead = value.disableQuickRead;
      disableStory = value.disableStory;

      termConditionCont.text = value.termCondition!;
      privacyPolicyCont.text = value.privacyPolicy!;
      contactInfoCont.text = value.contactInfo!;

      flutterWebBuildVersionCont.text = value.flutterWebBuildVersion.validate();
    }).catchError((e) {
      toast(errorSomethingWentWrong);
    });

    appStore.setLoading(false);
  }

  Future<void> save() async {
    if (appStore.isTester) return toast(mTesterNotAllowedMsg);

    appStore.setLoading(true);

    AppSettingModel appSettingModel = AppSettingModel();

    appSettingModel.disableAd = disableAd;
    appSettingModel.disableLocation = disableLocation;
    appSettingModel.disableHeadline = disableHeadline;
    appSettingModel.disableQuickRead = disableQuickRead;
    appSettingModel.disableStory = disableStory;

    appSettingModel.termCondition = termConditionCont.text.trim();
    appSettingModel.privacyPolicy = privacyPolicyCont.text.trim();
    appSettingModel.contactInfo = contactInfoCont.text.trim();

    appSettingModel.dashboardWidgetOrder = sharedPreferences.getStringList(DASHBOARD_WIDGET_ORDER);
    if (appSettingModel.dashboardWidgetOrder == null) appSettingModel.dashboardWidgetOrder = [];

    appSettingModel.flutterWebBuildVersion = flutterWebBuildVersionCont.text.trim();

    await appSettingService.updateDocument(appSettingModel.toJson(), appSettingService.id).then((value) async {
      await appSettingService.saveAppSettings(appSettingModel);

      toast('success_saved'.translate);
    }).catchError((e) {
      e.toString().toastString();
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('user_app_configs'.translate, style: boldTextStyle()).paddingLeft(16),
                  8.height,
                  Text('configs_will_be_loaded_every_time'.translate, style: secondaryTextStyle()).paddingLeft(16),
                  20.height,
                  Material(
                    elevation: 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('app_dashboard'.translate, style: boldTextStyle(color: colorPrimary)),
                      decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.1),
                        borderRadius: radius(),
                      ),
                      height: 100,
                      width: 200,
                    ).onTap(() {
                      AppDashboardConfigScreen().launch(context);
                    }),
                  ).paddingLeft(16),
                  20.height,
                  Container(
                    child: Wrap(
                      children: [
                        Container(
                          width: 500,
                          child: Column(
                            children: [
                              SettingItemWidget(
                                title: 'disable_adMob'.translate,
                                leading: Checkbox(
                                  value: disableAd,
                                  onChanged: (v) {
                                    disableAd = v;

                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  disableAd = !disableAd!;

                                  setState(() {});
                                },
                              ),
                              SettingItemWidget(
                                title: 'disable_location'.translate,
                                leading: Checkbox(
                                  value: disableLocation,
                                  onChanged: (v) {
                                    disableLocation = v;

                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  disableLocation = !disableLocation!;

                                  setState(() {});
                                },
                              ),
                              SettingItemWidget(
                                title: 'disable_headline'.translate,
                                leading: Checkbox(
                                  value: disableHeadline,
                                  onChanged: (v) {
                                    disableHeadline = v;

                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  disableHeadline = !disableHeadline!;

                                  setState(() {});
                                },
                              ),
                              SettingItemWidget(
                                title: 'disable_quickRead'.translate,
                                leading: Checkbox(
                                  value: disableQuickRead,
                                  onChanged: (v) {
                                    disableQuickRead = v;

                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  disableQuickRead = !disableQuickRead!;

                                  setState(() {});
                                },
                              ),
                              SettingItemWidget(
                                title: 'disable_story'.translate,
                                leading: Checkbox(
                                  value: disableStory,
                                  onChanged: (v) {
                                    disableStory = v;

                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  disableStory = !disableStory!;

                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 500,
                          child: Column(
                            children: [
                              AppTextField(
                                controller: termConditionCont,
                                textFieldType: TextFieldType.NAME,
                                decoration: inputDecoration(
                                  labelText: 'term_condition'.translate,
                                ),
                              ).paddingAll(16),
                              AppTextField(
                                controller: privacyPolicyCont,
                                textFieldType: TextFieldType.NAME,
                                decoration: inputDecoration(
                                  labelText: 'privacyPolicy'.translate,
                                ),
                              ).paddingAll(16),
                              AppTextField(
                                controller: contactInfoCont,
                                textFieldType: TextFieldType.NAME,
                                decoration: inputDecoration(
                                  labelText: 'contact_info'.translate,
                                ),
                              ).paddingAll(16),
                              AppTextField(
                                controller: flutterWebBuildVersionCont,
                                textFieldType: TextFieldType.NAME,
                                decoration: inputDecoration(
                                  labelText: 'flutter_web_build_version'.translate,
                                ),
                              ).paddingAll(16).visible(appStore.isAdmin),
                              AppButton(
                                text: 'save'.translate,
                                onTap: () => save(),
                                height: 60,
                                width: context.width(),
                              ).paddingAll(16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
