import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/UserModel.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class UserItemWidget extends StatefulWidget {
  static String tag = '/UserItemWidget';
  final UserModel data;

  UserItemWidget(this.data);

  @override
  _UserItemWidgetState createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> makeAdmin(bool value) async {
    widget.data.isAdmin = !widget.data.isAdmin.validate();
    setState(() {});

    await userService.updateDocument({UserKeys.isAdmin: value}, widget.data.id).then((res) {
      //
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          widget.data.image.validate().isNotEmpty
              ? cachedImage(
                  widget.data.image,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(30)
              : Icon(Feather.user, size: 60),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.name.validate(), style: boldTextStyle()),
              4.height,
              Text(widget.data.email.validate(), style: secondaryTextStyle()).visible(!appStore.isTester),
              4.height,
              Row(
                children: [
                  Text('${'last_login'.translate} ${widget.data.updatedAt!.timeAgo} |', style: secondaryTextStyle(size: 12)),
                  4.width,
                  SelectableText('${'one_signal_player_id'.translate} ${widget.data.oneSignalPlayerId.validate()}', style: secondaryTextStyle(size: 12)),
                  Icon(Icons.copy_outlined, size: 18).onTap(() {
                    widget.data.oneSignalPlayerId.copyToClipboard();

                    toast('copied'.translate);
                  }).visible(widget.data.oneSignalPlayerId!.isNotEmpty),
                ],
              ),
            ],
          ).expand(),
          16.width,
          AppButton(
            text: !widget.data.isAdmin.validate() ? 'make_admin'.translate : 'remove_admin'.translate,
            textStyle: boldTextStyle(color: widget.data.isAdmin.validate() ? Colors.green : colorPrimary, size: 14),
            shapeBorder: OutlineInputBorder(borderSide: BorderSide(color: context.dividerColor)),
            onTap: () {
              makeAdmin(!widget.data.isAdmin.validate());
            },
          ).visible(appStore.isAdmin && !appStore.isTester),
          8.width,
          IconButton(
            icon: Icon(Icons.delete_outline_outlined),
            onPressed: () {
              if (appStore.isTester) return toast(mTesterNotAllowedMsg);

              showConfirmDialog(context, 'delete_user'.translate, positiveText: 'yes'.translate, negativeText: 'no'.translate).then((value) {
                if (value ?? false) {
                  userService.removeDocument(widget.data.id).then((value) {
                    //
                  }).catchError((e) {
                    toast(e.toString());
                  });
                }
              });
            },
          ).visible(appStore.isAdmin),
        ],
      ),
    );
  }
}
