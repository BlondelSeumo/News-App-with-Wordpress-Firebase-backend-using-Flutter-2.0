import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/screens/user/UserDashboardScreen.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/RegisterScreen';
  final String? phoneNumber;

  RegisterScreen({this.phoneNumber});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      await signUpWithEmail(fullNameController.text.trim(), emailController.text.trim(), passwordController.text.trim()).then((value) {
        appStore.setLoading(false);

        UserDashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());

        appStore.setLoading(false);
      });

      /*createUser(request).then((res) async {
        if (!mounted) return;

        Map req = {'username': widget.phoneNumber ?? emailController.text, 'password': widget.phoneNumber ?? passwordController.text};

        await login(req).then((value) async {
          appStore.setLoading(false);

          if (widget.phoneNumber != null) await setValue(LOGIN_TYPE, LoginTypeOTP);

          UserDashboardScreen().launch(context, isNewTask: true);
        }).catchError((e) {
          appStore.setLoading(false);
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });*/
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30, top: 16, right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/app_logo.png', height: 100),
                    16.height,
                    Text('signUp_Title'.translate, style: boldTextStyle(size: 22)),
                    20.height,
                    AppTextField(
                      controller: fullNameController,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(labelText: 'full_name'.translate),
                      nextFocus: emailFocus,
                      autoFillHints: [AutofillHints.name],
                    ).paddingBottom(16),
                    AppTextField(
                      controller: emailController,
                      focus: emailFocus,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(labelText: 'email'.translate),
                      nextFocus: widget.phoneNumber != null ? null : passFocus,
                      errorThisFieldRequired: 'field_Required'.translate,
                      errorInvalidEmail: 'email_Validation'.translate,
                      maxLines: 1,
                      cursorColor: colorPrimary,
                      autoFillHints: [AutofillHints.email],
                    ).paddingBottom(16),
                    AppTextField(
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      nextFocus: confirmPasswordFocus,
                      decoration: inputDecoration(labelText: 'password'.translate),
                      isValidationRequired: widget.phoneNumber == null,
                      autoFillHints: [AutofillHints.newPassword],
                    ).paddingBottom(16).visible(widget.phoneNumber == null),
                    AppTextField(
                      controller: confirmPasswordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: confirmPasswordFocus,
                      decoration: inputDecoration(labelText: 'confirm_Pwd'.translate),
                      onFieldSubmitted: (s) {
                        signUp();
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return errorThisFieldRequired;
                        if (value.trim().length < passwordLengthGlobal) return 'password_length'.translate;
                        return passwordController.text == value.trim() ? null : 'password_not_match'.translate;
                      },
                      isValidationRequired: widget.phoneNumber == null,
                      autoFillHints: [AutofillHints.newPassword],
                    ).visible(widget.phoneNumber == null),
                    30.height,
                    AppButton(
                      text: 'signUp'.translate,
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                      textStyle: boldTextStyle(color: white),
                      onTap: () {
                        signUp();
                      },
                      width: context.width(),
                    ),
                    16.height,
                    AppButton(
                      text: 'login'.translate,
                      textStyle: boldTextStyle(color: textPrimaryColorGlobal),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : white,
                      onTap: () {
                        finish(context);
                      },
                      width: context.width(),
                    ),
                  ],
                ),
              ),
            ).center(),
            BackButton().paddingTop(30),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
