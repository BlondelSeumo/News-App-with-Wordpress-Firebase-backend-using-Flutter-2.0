import 'package:nb_utils/nb_utils.dart';

const mAppName = 'Mighty News';
const mWebName = 'Mighty News - Admin Panel';

String get appName => isMobile ? mAppName : mWebName;

const mNewsSource = 'MeetMighty';
const mAboutApp = '$mAppName app is a smart Flutter news app. It contains Flutter source code and to build your news application with most useful'
    ' features and eye-catching outlook. If you are planning to deploy your news app project for android and ios users, then it’s your'
    ' perfect match to have on your hand.';

const mFirebaseAppId = 'mighty-news-firebase.appspot.com';
const mAppIconUrl = 'https://firebasestorage.googleapis.com/v0/b/$mFirebaseAppId/o/app_logo.png?alt=media&token=55faf2c8-84ca-4776-80aa-c67222e58ff8';

const mFirebaseStorageFilePath = 'images';
const mTesterNotAllowedMsg = 'Tester role not allowed to perform this action';

//region URLs & Keys

const mOneSignalAppId = '7eb049a5-7244-46a7-8ee8-4acbf39837f5';
const mOneSignalRestKey = 'NDQ3MDJjY2MtN2FlMy00YzJlLTgwZDctOTg3MjdlZDA2MjRk';
const mOneSignalChannelId = 'fbecd235-877a-4023-9343-79284592e535';

const mAdMobAppId = 'ca-app-pub-1399327544318575~7227773588';
const mAdMobBannerId = 'ca-app-pub-1399327544318575/9662365239';
const mAdMobInterstitialId = 'ca-app-pub-1399327544318575/3096956884';

const supportURL = 'https://support.meetmighty.com/';
const codeCanyonURL = 'https://codecanyon.net/item/mightynews-flutter-news-app-with-wordpress-backend/29648579?s_rank=6';

const mWeatherBaseUrl = 'https://api.weatherapi.com/v1/current.json';

/// Obtain your key from https://api.weatherapi.com
const mWeatherAPIKey = 'ad7ec5bd89bc4a0b8e355959202611';

//endregion

const FilterByPost = 'filter_by_post';
const FilterByCategory = 'filter_by_category';

/// NewsType
const NewsTypeRecent = 'recent';
const NewsTypeBreaking = 'breaking';
const NewsTypeStory = 'story';

/// NewsStatus
const NewsStatusPublished = 'published';
const NewsStatusUnpublished = 'unpublished';
const NewsStatusDraft = 'draft';

/// Dashboard Widgets
const DashboardWidgetsBreakingNewsMarquee = 'BreakingNewsMarquee';
const DashboardWidgetsStory = 'Story';
const DashboardWidgetsBreakingNews = 'BreakingNews';
const DashboardWidgetsQuickRead = 'QuickRead';
const DashboardWidgetsRecentNews = 'RecentNews';

const DefaultLanguage = 'en';
const EnableSocialLogin = true;
const DocLimit = 10;

//App store URL
const appStoreBaseUrl = 'https://www.apple.com/app-store/';

//region LiveStream Keys
const StreamRefresh = 'StreamRefresh';
const StreamRefreshBookmark = 'StreamRefreshBookmark';
const StreamSelectItem = 'StreamSelectItem';
const StreamUpdateDrawer = 'StreamUpdateDrawer';
//endregion

/* Login Type */
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'otp';
const LoginTypeApple = 'apple';

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

List<String> adMobTestDevices = ['3610AB2566A57ABBD1D93687699877E2'];

//region SharedPreferences Keys

///User keys
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_ADMIN = 'IS_ADMIN';
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const FULL_NAME = 'FULL_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_ROLE = 'USER_ROLE';
const PASSWORD = 'PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const THEME_MODE_INDEX = "THEME_MODE_INDEX";
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const IS_REMEMBERED = "IS_REMEMBERED";
const LANGUAGE = 'LANGUAGE';
const PLAYER_ID = 'PLAYER_ID';
const IS_SOCIAL_LOGIN = 'IS_SOCIAL_LOGIN';
const LOGIN_TYPE = 'LOGIN_TYPE';
const BOOKMARKS = 'BOOKMARKS';
const POST_VIEWED_LIST = 'POST_VIEWED_LIST';

///

const IS_FIRST_TIME = 'IS_FIRST_TIME';
const TERMS_AND_CONDITION_PREF = 'TERMS_AND_CONDITION_PREF';
const PRIVACY_POLICY_PREF = 'PRIVACY_POLICY_PREF';
const CONTACT_PREF = 'CONTACT_PREF';
const FLUTTER_WEB_BUILD_VERSION = 'FLUTTER_WEB_BUILD_VERSION';
const DISABLE_LOCATION_WIDGET = 'DISABLE_LOCATION_WIDGET';
const DISABLE_QUICK_READ_WIDGET = 'DISABLE_QUICK_READ_WIDGET';
const DISABLE_STORY_WIDGET = 'DISABLE_STORY_WIDGET';
const DISABLE_HEADLINE_WIDGET = 'DISABLE_HEADLINE_WIDGET';
const DISABLE_AD = 'DISABLE_AD';
const FONT_SIZE_PREF = 'FONT_SIZE_PREF';
const DASHBOARD_WIDGET_ORDER = 'DASHBOARD_WIDGET_ORDER';

const DASHBOARD_DATA = 'DASHBOARD_DATA';
//endregion
