import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  var oldPassCont = TextEditingController();
  var newPassCont = TextEditingController();
  var confNewPassCont = TextEditingController();

  var newPassFocus = FocusNode();
  var confPassFocus = FocusNode();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  Future<void> submit() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      await changePassword(newPassCont.text.trim()).then((value) async {
        finish(context);
        toast('Password successfully changed');
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !isIos,
      child: Scaffold(
        appBar: appBarWidget(
          'change_Pwd'.translate,
          showBack: true,
          elevation: 0,
          color: getAppBarWidgetBackGroundColor(),
          textColor: getAppBarWidgetTextColor(),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: oldPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(labelText: 'password'.translate),
                        nextFocus: newPassFocus,
                        textStyle: primaryTextStyle(),
                        autoFillHints: [AutofillHints.password],
                        validator: (s) {
                          if (s!.isEmpty) return errorThisFieldRequired;
                          if (s != getStringAsync(PASSWORD)) return 'old_pwd_incorrect'.translate;

                          return null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: newPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(labelText: 'new_password'.translate),
                        focus: newPassFocus,
                        nextFocus: confPassFocus,
                        textStyle: primaryTextStyle(),
                        autoFillHints: [AutofillHints.newPassword],
                      ),
                      16.height,
                      AppTextField(
                        controller: confNewPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(labelText: 'confirm_Password'.translate),
                        focus: confPassFocus,
                        validator: (String? value) {
                          if (value!.isEmpty) return errorThisFieldRequired;
                          if (value.length < passwordLengthGlobal) return 'password_length'.translate;
                          if (value.trim() != newPassCont.text.trim()) return 'confirmPwdValidation'.translate;
                          if (value.trim() == oldPassCont.text.trim()) return 'old_pwd_not_same_new'.translate;

                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (s) {
                          submit();
                        },
                        textStyle: primaryTextStyle(),
                        autoFillHints: [AutofillHints.newPassword],
                      ),
                      30.height,
                      AppButton(
                        onTap: () {
                          submit();
                        },
                        text: 'save'.translate,
                        width: context.width(),
                        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
