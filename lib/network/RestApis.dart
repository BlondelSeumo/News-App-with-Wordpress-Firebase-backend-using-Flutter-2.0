import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:mighty_news_firebase/models/WeatherResponse.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NetworkUtils.dart';

Future<bool> sendPushNotifications(String title, String content, {String? id, String? image}) async {
  Map req = {
    'headings': {
      'en': title,
    },
    'contents': {
      'en': content,
    },
    'big_picture': image.validate().isNotEmpty ? image.validate() : '',
    'large_icon': image.validate().isNotEmpty ? image.validate() : '',
    'small_icon': mAppIconUrl,
    'data': {
      'id': id,
    },
    'app_id': mOneSignalAppId,
    'android_channel_id': mOneSignalChannelId,
    'included_segments': ['All'],
  };
  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode);
  log(res.body);

  if (res.statusCode.isSuccessful()) {
    return true;
  } else {
    throw errorSomethingWentWrong;
  }
}

//region Third Party APIs
Future<WeatherResponse> getWeatherApi() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    Position? position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      position = await Geolocator.getCurrentPosition();
    }

    return WeatherResponse.fromJson(
      await handleResponse(await buildHttpResponse('$mWeatherBaseUrl?key=$mWeatherAPIKey&q=${position.latitude},${position.longitude}'), true),
    );
  } else {
    throw errorSomethingWentWrong;
  }
}
//endregion
