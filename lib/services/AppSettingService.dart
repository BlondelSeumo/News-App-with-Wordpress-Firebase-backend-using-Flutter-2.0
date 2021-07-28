import 'package:mighty_news_firebase/models/AppSettingModel.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'BaseService.dart';

class AppSettingService extends BaseService {
  String? id;

  AppSettingService() {
    ref = db.collection('settings');
  }

  Future<AppSettingModel> getAppSettings() async {
    return await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;

        return AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        return await setAppSettings();
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<AppSettingModel> setAppSettings() async {
    AppSettingModel appSettingModel = AppSettingModel();

    //region Default values
    appSettingModel.disableAd = false;
    appSettingModel.disableLocation = false;
    appSettingModel.disableHeadline = false;
    appSettingModel.disableQuickRead = false;
    appSettingModel.disableStory = false;

    appSettingModel.termCondition = '';
    appSettingModel.privacyPolicy = '';
    appSettingModel.contactInfo = '';
    appSettingModel.flutterWebBuildVersion = '';

    appSettingModel.dashboardWidgetOrder = [];
    //endregion

    return await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        appSettingModel = await ref!.get().then((value) => AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>));
      } else {
        await addDocument(appSettingModel.toJson()).then((value) {
          id = value.id;
        }).catchError((e) {
          log(e);
        });
      }

      await saveAppSettings(appSettingModel);

      LiveStream().emit(StreamRefresh, true);

      return appSettingModel;
    });
  }

  Future<void> saveAppSettings(AppSettingModel appSettingModel) async {
    await setValue(DISABLE_AD, appSettingModel.disableAd.validate());
    await setValue(DISABLE_LOCATION_WIDGET, appSettingModel.disableLocation.validate());
    await setValue(DISABLE_HEADLINE_WIDGET, appSettingModel.disableHeadline.validate());
    await setValue(DISABLE_QUICK_READ_WIDGET, appSettingModel.disableQuickRead.validate());
    await setValue(DISABLE_STORY_WIDGET, appSettingModel.disableStory.validate());

    await setValue(TERMS_AND_CONDITION_PREF, appSettingModel.termCondition.validate());
    await setValue(PRIVACY_POLICY_PREF, appSettingModel.privacyPolicy.validate());
    await setValue(CONTACT_PREF, appSettingModel.contactInfo.validate());
    await setValue(FLUTTER_WEB_BUILD_VERSION, appSettingModel.flutterWebBuildVersion.validate());

    await setValue(DASHBOARD_WIDGET_ORDER, appSettingModel.dashboardWidgetOrder);
  }
}
