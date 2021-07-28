import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SocialLoginWidget extends StatelessWidget {
  static String tag = '/SocialLoginWidget';
  final VoidCallback? voidCallback;

  SocialLoginWidget({this.voidCallback});

  @override
  Widget build(BuildContext context) {
    if (!EnableSocialLogin) return SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkMode ? Colors.white12 : Colors.grey.shade100),
          child: IconButton(
            icon: GoogleLogoWidget(size: 22),
            onPressed: () async {
              hideKeyboard(context);

              appStore.setLoading(true);

              await signInWithGoogle().then((user) {
                appStore.setLoading(false);
                //DashboardScreen().launch(context, isNewTask: true);

                voidCallback?.call();
              }).catchError((e) {
                appStore.setLoading(false, toastMsg: e.toString());
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 4),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkMode ? Colors.white12 : Colors.grey.shade100),
          child: IconButton(
            icon: Icon(Feather.phone, color: Colors.blue),
            onPressed: () async {
              toast('Coming soon');
              return;

              hideKeyboard(context);

              appStore.setLoading(true);

              /*await showInDialog(context, child: OTPDialog(), barrierDismissible: false).catchError((e) {
                toast(e.toString());
              });*/

              appStore.setLoading(false);
              voidCallback?.call();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 4),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkMode ? Colors.white12 : Colors.grey.shade100),
          child: IconButton(
            icon: Icon(AntDesign.apple1),
            onPressed: () async {
              hideKeyboard(context);
              appStore.setLoading(true);

              await appleLogIn().then((value) {
                //DashboardScreen().launch(context, isNewTask: true);

                voidCallback?.call();
              }).catchError((e) {
                toast(e.toString());
              });
              appStore.setLoading(false);
            },
          ),
        ).visible(isIos),
      ],
    );
  }
}
