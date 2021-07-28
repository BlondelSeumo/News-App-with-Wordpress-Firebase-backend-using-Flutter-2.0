import 'package:nb_utils/nb_utils.dart';

const mAppName = 'Mighty News';

//region URLs & Keys
/// Note: /wp-json/ is required after your domain. Ex if your domain is www.abc.com then ${mBaseUrl} will be  https://www.abc.com/wp-json/
const mBaseUrl = 'https://meetmighty.com/mobile/mightynews/wp-json/';
// const mBaseUrl = 'http://192.168.1.230/wp_plugin/mightynews/wp-json/';

const supportURL = 'https://support.meetmighty.com/';
const codeCanyonURL = 'https://codecanyon.net/item/mightynews-flutter-news-app-with-wordpress-backend/29648579?s_rank=3';

const mWeatherBaseUrl = 'https://api.weatherapi.com/v1/current.json';

const mTTSImageUrl = 'https://3.bp.blogspot.com/-BogykpVgXv8/WYeJk--8xOI/AAAAAAAACWk/GORfjYPnTMoeeMH7uV61H0SPBy02j4ERACLcBGAs/s1600/Relaxing%2BQuotes%2Bwww.mostphrases.blogspot.com.jpg';

/// Obtain your key from https://api.weatherapi.com
const mWeatherAPIKey = 'ad7ec5bd89bc4a0b8e355959202611';

const mOneSignalAPPKey = 'ef3464af-8a83-49b0-943e-070072d8e377';

var mTwitterApiKey = 'a1kyf4tugag2ayYR1Aewf7a6u';
var mTwitterApiSecretKey = '7viRNGALBsfS2pO8ZYAeUcyZT6aHB1gc680koJn8IWEdfwFG4A';
var mTwitterApiAccessToken = '1347489470736519170-4gUb0e8NZak3GUGOsfLjEEtuimdFtZ';
var mTwitterApiAccessTokenSecret = '63udaSTslbqpzn1dYqBOJ6wkD4t9wYY5M52of2VV1IHU4';

const mAdMobAppId = 'ca-app-pub-1399327544318575~7586962359';
const mAdMobBannerId = 'ca-app-pub-1399327544318575/7395390664';
const mAdMobInterstitialId = 'ca-app-pub-1399327544318575/2840712768';
//endregion

//App store URL
const appStoreBaseUrl = 'https://www.apple.com/app-store/';

//region LiveStream Keys
const checkMyTopics = 'checkMyTopics';
const refreshBookmark = 'refreshBookmark';
const tokenStream = 'tokenStream';
//endregion

//region Configs
const defaultLanguage = 'en';
const defaultTTSLanguage = 'en-US';
const postsPerPage = 15;
const dashboard3ItemTwitterLine = 7;
const enableSocialLogin = true;

const dashboard3Item = 280.0;

const dashboard1ComponentHeight = 200.0;
const dashboard2ComponentHeight = 230.0;
const dashboard3ComponentHeight = 280.0;

const DASHBOARD2_Video = 200.0;

//endregion

//region Messages
var passwordLengthMsg = 'Password length should be more than $passwordLengthGlobal';
//endregion

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

/* Video Type */
const VideoTypeCustom = 'custom_url';
const VideoTypeYouTube = 'youtube';
const VideoTypeIFrame = 'iframe';

/* Login Type */
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeApple = 'apple';
const LoginTypeOTP = 'otp';

/* Firebase Remote Config Keys */
const LAST_UPDATE_DATE = 'lastUpdateDate';
const FORCE_UPDATE_VERSION_CODE = 'forceUpdateVersionCode';

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_TWITTER_LOGGED_IN = 'IS_TWITTER_LOGGED_IN';
const TWITTER_USERNAME = 'TWITTER_USERNAME';
const TWITTER_ACCESS_TOKEN = 'TWITTER_ACCESS_TOKEN';
const TOKEN = 'TOKEN';
const USER_ID = 'USER_ID';
const USERNAME = 'USERNAME';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_ROLE = 'USER_ROLE';
const AVATAR = 'AVATAR';
const PASSWORD = 'PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const IS_REMEMBERED = "IS_REMEMBERED";
const LANGUAGE = 'LANGUAGE';
const PLAYER_ID = 'playerId';
const FONT_SIZE = 'FONT_SIZE';
const MY_TOPICS = 'MY_TOPICS';
const TERMS_AND_CONDITION_PREF = 'TermsAndConditionPref';
const PRIVACY_POLICY_PREF = 'PrivacyPolicyPref';
const CONTACT_PREF = 'ContactPref';
const DISABLE_LOCATION_WIDGET = 'DISABLE_LOCATION_WIDGET';
const DISABLE_TWITTER_WIDGET = 'DISABLE_TWITTER_WIDGET';
const DISABLE_QUICK_READ_WIDGET = 'DISABLE_QUICK_READ_WIDGET';
const DISABLE_STORY_WIDGET = 'DISABLE_STORY_WIDGET';
const DISABLE_HEADLINE_WIDGET = 'DISABLE_HEADLINE_WIDGET';
const DISABLE_AD = 'DisableAd';
const FONT_SIZE_PREF = 'FontSizePref';
const IS_SOCIAL_LOGIN = 'IsSocialLogin';
const DETAIL_PAGE_VARIANT = 'DetailPageVariant';
const LOGIN_TYPE = 'LOGIN_TYPE';
const MY_PREFERENCE = 'my_preference';
const DASHBOARD_PAGE_VARIANT = 'DashboardPageVariant';
const COPYRIGHT_TEXT = 'COPYRIGHT_TEXT';

const TEXT_TO_SPEECH_LANG = 'TEXT_TO_SPEECH_LANG';

// Crypto Currency
const BITCOIN_PRICE = 'BITCOIN_PRICE';
const BITCOIN_CHANGE = 'BITCOIN_CHANGE';
const ETHEREUM_PRICE = 'ETHEREUM_PRICE';
const ETHEREUM_CHANGE = 'ETHEREUM_CHANGE';
const CURRENT_TIME = 'CURRENT_TIME';
//

// Offline Data
const DASHBOARD_DATA = 'DASHBOARD_DATA';
const NEWS_DETAIL = 'NEWS_DETAIL';
const VIEW_ALL_DATA = 'VIEW_ALL_DATA';
const CATEGORY_DATA = 'CATEGORY_DATA';
const SEARCH_DATA = 'SEARCH_DATA';
//

//endregion

/* breaking news */
const FILTER = 'filter';
const FILTER_FEATURE = 'feature';
