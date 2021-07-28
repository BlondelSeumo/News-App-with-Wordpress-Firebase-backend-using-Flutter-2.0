import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/WeatherResponse.dart';
import 'package:mighty_news_firebase/network/RestApis.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class WeatherWidget extends StatelessWidget {
  static String tag = '/WeatherWidget';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherResponse>(
      future: weatherMemoizer.runOnce(() => getWeatherApi()),
      builder: (_, snap) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: context.cardColor, blurRadius: 0.6, spreadRadius: 1.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snap.hasData ? snap.data!.location!.name.validate() : '-',
                    style: boldTextStyle(size: 28),
                    overflow: TextOverflow.ellipsis,
                  ).paddingLeft(8),
                  4.height,
                  Text(
                    'news_feed'.translate,
                    style: secondaryTextStyle(),
                  ).paddingLeft(8),
                ],
              ).expand(),
              Row(
                children: [
                  snap.hasData
                      ? cachedImage(
                          'https:${snap.data!.current!.condition?.icon?.validate()}',
                          height: 50,
                          usePlaceholderIfUrlEmpty: false,
                        ).paddingRight(8)
                      : SizedBox(),
                  Text(
                    (snap.hasData ? '${snap.data!.current!.temp_c.validate().toInt().toString()}°' : '-'),
                    style: boldTextStyle(size: 30),
                  ).paddingRight(8),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
