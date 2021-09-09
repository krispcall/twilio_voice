import 'package:flutter/foundation.dart';
import 'package:voice_example/viewobject/common/Language.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';

class Config {
  Config._();

  // App Version
  static const String appVersion = '1.0.20';

  ///QA
  // static const String liveUrl = kReleaseMode
  //     ? 'https://qa.krispcall.com/api/v1/graphql/'
  //     : 'https://qa.krispcall.com/api/v1/graphql/';
  // static const String socketUrl = kReleaseMode
  //     ? 'wss://qa.krispcall.com/api/v1/graphql'
  //     : 'wss://qa.krispcall.com/api/v1/graphql';
  //
  // static const String APP_SUBSCRIPTION_ENDPOINT =
  //     "wss://qa.krispcall.com/api/v1/graphql/";
  //
  // //Image Upload Folder URLde
  // static const String imageUrl = 'https://qa.krispcall.com';
  // static const String countryLogoUrl =
  //     kReleaseMode ? 'https://qa.krispcall.com' : 'https://qa.krispcall.com';
  ///QA

  ///
  ///
  ///Harris NGROK
  // static const String liveUrl = kReleaseMode
  //     ? 'http://81db-110-34-27-12.in.ngrok.io/api/v1/graphql/'
  //     : 'http://81db-110-34-27-12.in.ngrok.io/api/v1/graphql/';
  // static const String socketUrl = kReleaseMode
  //     ? 'wss://81db-110-34-27-12.in.ngrok.io/api/v1/graphql'
  //     : 'wss://81db-110-34-27-12.in.ngrok.io/api/v1/graphql';
  //
  // static const String APP_SUBSCRIPTION_ENDPOINT =
  //     "wss://81db-110-34-27-12.in.ngrok.io/api/v1/graphql/";
  //
  // //Image Upload Folder URLde
  // static const String imageUrl = 'http://81db-110-34-27-12.in.ngrok.io';
  // static const String countryLogoUrl =
  // kReleaseMode ? 'http://81db-110-34-27-12.in.ngrok.io' : 'http://81db-110-34-27-12.in.ngrok.io';
  ///Harris NGROK
  ///
  ///QA
  // static const String liveUrl = kReleaseMode
  //     ? 'https://qa.krispcall.com/api/v1/graphql/'
  //     : 'https://qa.krispcall.com/api/v1/graphql/';
  // static const String socketUrl = kReleaseMode
  //     ? 'wss://qa.krispcall.com/api/v1/graphql'
  //     : 'wss://qa.krispcall.com/api/v1/graphql';
  //
  // static const String APP_SUBSCRIPTION_ENDPOINT =
  //     "wss://qa.krispcall.com/api/v1/graphql/";
  //
  // //Image Upload Folder URLde
  // static const String imageUrl = 'https://qa.krispcall.com';
  // static const String countryLogoUrl =
  //     kReleaseMode ? 'https://qa.krispcall.com' : 'https://qa.krispcall.com';
  ///QA

  ///Development
  // static const String liveUrl = kReleaseMode
  //     ? 'https://dev.krispcall.com/api/v1/graphql/'
  //     : 'https://dev.krispcall.com/api/v1/graphql/';
  // static const String socketUrl = kReleaseMode
  //     ? 'wss://dev.krispcall.com/api/v1/graphql'
  //     : 'wss://dev.krispcall.com/api/v1/graphql';
  //
  // static const String APP_SUBSCRIPTION_ENDPOINT =
  //     "wss://dev.krispcall.com/api/v1/graphql/";
  //
  // Image Upload Folder URLde
  // static const String imageUrl = 'https://dev.krispcall.com';
  // static const String countryLogoUrl =
  //     kReleaseMode ? 'https://dev.krispcall.com' : 'https://dev.krispcall.com';

  ///Development


  ///MVP
  static const String liveUrl = kReleaseMode
      ? 'https://mvp.krispcall.com/api/v1/graphql/'
      : 'https://mvp.krispcall.com/api/v1/graphql/';
  static const String socketUrl = kReleaseMode
      ? 'wss://mvp.krispcall.com/api/v1/graphql'
      : 'wss://mvp.krispcall.com/api/v1/graphql';

  static const String APP_SUBSCRIPTION_ENDPOINT =
      "wss://mvp.krispcall.com/api/v1/graphql/";

  //Image Upload Folder URLde
  static const String imageUrl = 'https://mvp.krispcall.com';
  static const String countryLogoUrl =
      kReleaseMode ? 'https://mvp.krispcall.com' : 'https://mvp.krispcall.com';

  ///MVP

  //Thumbnail generated folder URL
  static const String ps_app_image_thumbs_url =
      'https://miro.medium.com/max/1838/1*MI686k5sDQrISBM6L8pf5A.jpeg';

  // Animation Duration
  static const Duration animation_duration = Duration(milliseconds: 100);

  // Font Family
  static const String heeboRegular = 'HeeboRegular';
  static const String heeboMedium = 'HeeboMedium';
  static const String heeboBlack = 'HeeboBlack';
  static const String heeboBold = 'HeeboBold';
  static const String heeboExtraBold = 'HeeboExtraBold';
  static const String heeboLight = 'HeeboLight';
  static const String heeboThin = 'HeeboThin';
  static const String manropeRegular = 'ManropeRegular';
  static const String manropeMedium = 'ManropeMedium';
  static const String manropeBold = 'ManropeBold';
  static const String manropeExtraBold = 'ManropeExtraBold';
  static const String manropeLight = 'ManropeLight';
  static const String manropeSemiBold = 'ManropeSemiBold';
  static const String manropeThin = 'ManropeThin';

  static const String app_db_name = 'krispcallMVP.db';

  static final Language defaultLanguage =
      Language(languageCode: 'en', countryCode: 'US', name: 'English US');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
  ];

  static final List<ColorHolder> supportColorHolder = <ColorHolder>[
    ColorHolder(
      id: '1',
      colorTitle: 'Green',
      colorCode: '#3EB53E',
      backgroundColorCode: '#DBEACF',
      isChecked: false,
    ),
    ColorHolder(
      id: '2',
      colorTitle: 'Blue',
      colorCode: '#155BDB',
      backgroundColorCode: '#E9F0FE',
      isChecked: false,
    ),
    ColorHolder(
      id: '3',
      colorTitle: 'Yellow',
      colorCode: '#FFAE00',
      backgroundColorCode: '#FCF2E7',
      isChecked: false,
    ),
    ColorHolder(
      id: '4',
      colorTitle: 'Mustard',
      colorCode: '#C29D3B',
      backgroundColorCode: '#FFF3D3',
      isChecked: false,
    ),
    ColorHolder(
      id: '5',
      colorTitle: 'Red',
      colorCode: '#DB312B',
      backgroundColorCode: '#FCEBEA',
      isChecked: false,
    ),
    ColorHolder(
      id: '6',
      colorTitle: 'Gray',
      colorCode: '#56666D',
      backgroundColorCode: '#E8F0F1',
      isChecked: false,
    ),
    ColorHolder(
      id: '7',
      colorTitle: 'Purple',
      colorCode: '#BB6BD9',
      backgroundColorCode: '#F9E9FF',
      isChecked: false,
    ),
  ];

  // iOS App No
  static const String iOSAppStoreId = '1515087604';

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 20;

  static const String dateFormat = "yyyy-MM-dd";
  static const String dateFullMonthYearAndTimeFormat = 'MMMM dd, y';
}
