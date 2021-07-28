import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordDialog extends StatefulWidget {
  static String tag = '/ForgotPasswordDialog';

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController emailCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> submit(AppLocalizations? appLocale) async {
    if (emailCont.text.trim().isEmpty) return toast(errorThisFieldRequired);

    if (!emailCont.text.trim().validateEmail()) return toast(appLocale!.translate('email_is_invalid'));

    hideKeyboard(context);
    appStore.setLoading(true);

    if (await userService.isUserExist(emailCont.text, LoginTypeApp)) {
      ///
      await auth.sendPasswordResetEmail(email: emailCont.text).then((value) {
        toast('Reset email has been sent to ${emailCont.text}');

        finish(context);
      }).catchError((e) {
        toast(e.toString());
      });

      ///
      appStore.setLoading(false);

      /*await forgotPassword(req).then((value) {
        toast(value.message);
        finish(context);
      }).catchError((e) {
        toast(e.toString());
      });*/
    } else {
      toast('No User Found');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appLocalizations!.translate('forgot_pwd'), style: boldTextStyle()),
              CloseButton(),
            ],
          ),
          8.height,
          AppTextField(
            controller: emailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(hintText: appLocalizations!.translate('email')),
            textStyle: primaryTextStyle(),
            autoFocus: true,
          ),
          30.height,
          Stack(
            alignment: Alignment.center,
            children: [
              AppButton(
                text: appLocalizations!.translate('submit'),
                color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                textStyle: boldTextStyle(color: white),
                onTap: () {
                  submit(appLocalizations);
                },
                width: context.width(),
              ),
              Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            ],
          ),
        ],
      ),
    );
  }
}
