import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

class AboutAppScreen extends StatelessWidget {
  static String tag = '/AboutAppScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !isIos,
      child: Scaffold(
        appBar: appBarWidget("about".translate, showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mAppName, style: primaryTextStyle(size: 30)),
              16.height,
              Container(
                decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(4)),
                height: 4,
                width: 100,
              ),
              16.height,
              Text('version'.translate, style: secondaryTextStyle()),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('${snap.data!.version.validate()}', style: primaryTextStyle());
                  }
                  return SizedBox();
                },
              ),
              16.height,
              Text('news_source'.translate, style: secondaryTextStyle()),
              Text(mNewsSource, style: primaryTextStyle()),
              16.height,
              Text(
                mAboutApp,
                style: primaryTextStyle(size: 14),
                textAlign: TextAlign.justify,
              ),
              16.height,
              AppButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.contact_support_outlined),
                    8.width,
                    Text('contact'.translate, style: boldTextStyle()),
                  ],
                ),
                onTap: () {
                  launchUrl('mailto:${getStringAsync(CONTACT_PREF)}');
                },
              ),
              16.height,
              AppButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/purchase.png', height: 24),
                    8.width,
                    Text('purchase'.translate, style: boldTextStyle()),
                  ],
                ),
                onTap: () {
                  launchUrl(codeCanyonURL);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
