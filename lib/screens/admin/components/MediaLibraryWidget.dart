import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/services/FileStorageService.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class MediaLibraryWidget extends StatefulWidget {
  static String tag = '/MediaLibraryWidget';

  @override
  MediaLibraryWidgetState createState() => MediaLibraryWidgetState();
}

class MediaLibraryWidgetState extends State<MediaLibraryWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: FutureBuilder(
        future: listOfFileFromFirebaseStorage(),
        builder: (_, snap) {
          log(snap.error);

          return Offstage(
            offstage: !snap.hasError,
            child: Text('coming_soon'.translate, style: secondaryTextStyle()).center(),
          );
        },
      ),
    );
  }
}
