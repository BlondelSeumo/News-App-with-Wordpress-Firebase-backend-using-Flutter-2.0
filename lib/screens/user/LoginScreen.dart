import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/components/ForgotPasswordDialog.dart';
import 'package:mighty_news_firebase/components/LanguageSelectionWidget.dart';
import 'package:mighty_news_firebase/components/SocialLoginWidget.dart';
import 'package:mighty_news_firebase/services/AuthService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../main.dart';
import 'RegisterScreen.dart';
import 'UserDashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  final bool? isNewTask;

  LoginScreen({this.isNewTask});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool passwordVisible = false;

  bool isRemembered = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (!getBoolAsync(IS_SOCIAL_LOGIN) && getStringAsync(LOGIN_TYPE) != LoginTypeOTP && !getBoolAsync(IS_REMEMBERED)) {
      emailController.text = getStringAsync(USER_EMAIL);
      passwordController.text = getStringAsync(PASSWORD);
    }
    if (isIos) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }
    setState(() {});

    setDynamicStatusBarColor();
  }

  Future<void> signIn() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      await signInWithEmail(emailController.text, passwordController.text).then((user) {
        if (user != null) {
          if (widget.isNewTask.validate()) {
            UserDashboardScreen().launch(context, isNewTask: true);
          } else {
            finish(context, true);
          }
        }
      }).catchError((e) {
        log(e);
        toast(e.toString().splitAfter(']').trim());
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
    appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/app_logo.png', height: 100),
                    16.height,
                    Text('login_Title'.translate, style: boldTextStyle(size: 22)),
                    20.height,
                    AppTextField(
                      controller: emailController,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(labelText: 'email'.translate),
                      nextFocus: passFocus,
                      autoFillHints: [AutofillHints.email],
                    ),
                    8.height,
                    AppTextField(
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      decoration: inputDecoration(labelText: 'password'.translate),
                      autoFillHints: [AutofillHints.password],
                      onFieldSubmitted: (s) {
                        signIn();
                      },
                    ),
                    8.height,
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: getBoolAsync(IS_REMEMBERED, defaultValue: true),
                              onChanged: (v) async {
                                await setValue(IS_REMEMBERED, v);
                                setState(() {});
                              },
                            ),
                            Text('remember_me'.translate, style: primaryTextStyle()).onTap(() async {
                              await setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                              setState(() {});
                            }).expand(),
                          ],
                        ).expand(),
                        Text('forgot_pwd'.translate, style: primaryTextStyle()).paddingAll(8).onTap(() async {
                          hideKeyboard(context);
                          await showInDialog(context, child: ForgotPasswordDialog());
                        }),
                      ],
                    ),
                    8.height,
                    AppButton(
                      text: 'login'.translate,
                      textStyle: boldTextStyle(color: white),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                      onTap: () {
                        signIn();
                      },
                      width: context.width(),
                    ),
                    16.height,
                    AppButton(
                      text: 'signUp'.translate,
                      textStyle: boldTextStyle(color: textPrimaryColorGlobal),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : white,
                      width: context.width(),
                      onTap: () {
                        hideKeyboard(context);
                        RegisterScreen().launch(context);
                      },
                    ),
                    16.height,
                    SocialLoginWidget(voidCallback: () {
                      UserDashboardScreen().launch(context, isNewTask: true);
                    }),
                    LanguageSelectionWidget(),
                  ],
                ),
              ),
            ).center(),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            BackButton().paddingTop(30),
          ],
        ),
      ),
    );
  }
}
