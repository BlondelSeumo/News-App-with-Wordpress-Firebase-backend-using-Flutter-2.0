import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/services/FileStorageService.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool passwordVisible = false;

  bool isLoading = false;

  PickedFile? image;

  @override
  void initState() {
    super.initState();
    init();

    setDynamicStatusBarColor();
  }

  Future<void> init() async {
    fullNameController.text = getStringAsync(FULL_NAME);
    emailController.text = getStringAsync(USER_EMAIL);
  }

  Future save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      isLoading = true;
      setState(() {});

      Map<String, dynamic> req = {};

      if (fullNameController.text != getStringAsync(FULL_NAME)) {
        req.putIfAbsent('name', () => fullNameController.text.trim());
      }

      if (image != null) {
        await uploadFile(file: File(image!.path), prefix: 'userProfiles').then((path) async {
          req.putIfAbsent('image', () => path);

          await setValue(PROFILE_IMAGE, path);
          appStore.setUserProfile(path);
        }).catchError((e) {
          toast(e.toString());
        });
      }

      await userService.updateDocument(req, appStore.userId).then((value) async {
        isLoading = false;
        appStore.setFullName(fullNameController.text);
        setValue(FULL_NAME, fullNameController.text);

        finish(context);
      });
    }
  }

  Future getImage() async {
    if (!isLoggedInWithGoogle() && !isLoggedInWithApple()) {
      image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget profileImage() {
      if (image != null) {
        return Image.file(File(image!.path), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
      } else {
        if (getStringAsync(LOGIN_TYPE) == LoginTypeGoogle || getStringAsync(LOGIN_TYPE) == LoginTypeApp || getStringAsync(LOGIN_TYPE) == LoginTypeApple) {
          return cachedImage(appStore.userProfileImage, height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
        } else {
          return Icon(Icons.person_outline_rounded).paddingAll(16);
        }
      }
    }

    return SafeArea(
      top: !isIos,
      child: Scaffold(
        appBar: appBarWidget('edit_Profile'.translate, showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 16,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                              child: profileImage(),
                            ),
                            Text(
                              'change_avatar'.translate,
                              style: boldTextStyle(),
                            ).paddingTop(16).visible(!isLoggedInWithGoogle() && !isLoggedInWithApple()),
                          ],
                        ).paddingOnly(top: 16, bottom: 16),
                      ).onTap(() {
                        getImage();
                      }),
                      16.height,
                      AppTextField(
                        controller: fullNameController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: 'full_name'.translate),
                        textStyle: isLoggedInWithApp() ? primaryTextStyle() : secondaryTextStyle(),
                        enabled: isLoggedInWithApp(),
                      ),
                      16.height,
                      AppTextField(
                        controller: emailController,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: inputDecoration(labelText: 'email'.translate),
                        textStyle: secondaryTextStyle(),
                        enabled: false,
                      ),
                      30.height,
                      AppButton(
                        text: 'save'.translate,
                        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                        enabled: isLoggedInWithApp(),
                        onTap: () {
                          save();
                        },
                        width: context.width(),
                      ).visible(isLoggedInWithApp()),
                    ],
                  ),
                ),
              ),
            ),
            Loader().center().visible(isLoading),
          ],
        ),
      ),
    );
  }
}
