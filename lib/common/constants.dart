import 'package:flutter/material.dart'
    show Alignment, BoxDecoration, Color, LinearGradient;
import 'package:weekly_planner/common/extensions.dart';

/// URL ------------------------------------------------------------------------
class R {
  R._();
  static String get appName => 'Weekly Planner';
  static FlexS3Identifiers get s3Identifiers => const FlexS3Identifiers._();
  static FlexUrl get urls => const FlexUrl._();
  static FlexColors get colors => const FlexColors._();
  static FlexAssets get assets => const FlexAssets._();
  static CacheDirectories get directories => const CacheDirectories._();
}
/// ----------------------------------------------------------------------------

/// AWS S3 ---------------------------------------------------------------------
class FlexS3Identifiers {
  const FlexS3Identifiers._();
  String get bucketName => 'flexsport-media-main';
  String get region => 'eu-central-1';
}
/// ----------------------------------------------------------------------------

/// URLs -----------------------------------------------------------------------
class FlexUrl {
  const FlexUrl._();
  // static const String fitGamesDomain = 'https://api-mobile.flexsport.de/';
  // static const String fitGamesDomain = 'https://vfg7dkq7rbkmmsnje27ffkc2cm0kwicw.lambda-url.eu-central-1.on.aws/';
  static const String fitGamesDomain = '';
  String get termsAndConditions => 'https://pages.flycricket.io/flexsports-0/terms.html';
  String get privacyPolicy => 'https://pages.flycricket.io/flexsports-0/privacy.html';
  String get deleteProfile => '${FlexUrl.fitGamesDomain}user';
  String preSignedUrl({required String objectKey}) => '${FlexUrl.fitGamesDomain}presigned_url?key=$objectKey';
}

/// Colors ---------------------------------------------------------------------
class FlexColors {
  const FlexColors._();
  Color get appPrimaryColor => const Color(0xFF009FE3);
  Color get timerBackgroundColor => '#393939'.hexToColor;
  Color get workoutCardBackgroundColor => '#1E1E1E'.hexToColor;
  Color get workoutCardInnerContainerColor => '#303030'.hexToColor;
  Color get darkGreyColor => '#262626'.hexToColor;
  Color get videoCardColor => '#424242'.hexToColor;
  Color get alephLogoColor => '#004980'.hexToColor;
  BoxDecoration get mainBackgroundGradient => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.4174, 0.93],
          colors: ['#000000'.hexToColor, '#2B2B2B'.hexToColor],
        ),
      );
}
/// ----------------------------------------------------------------------------

/// Assets  --------------------------------------------------------------------
class FlexAssets {
  const FlexAssets._();

  AssetImages get images => const AssetImages._();
}
/// ----------------------------------------------------------------------------

/// Images ---------------------------------------------------------------------
class AssetImages {
  const AssetImages._();
  String get aeLogo => 'assets/svg/ae_logo.svg';
}
/// ----------------------------------------------------------------------------

/// Cache Directories ----------------------------------------------------------
class CacheDirectories {
  const CacheDirectories._();
  String get dirAssetsPath => 'assets';
  String get dirManualPath => 'manual';
  String get dirAudioPath => 'audio';
  String get dirVideoPath => 'video';
  String get dirRunDrillsPath => 'run_drills';
  String get dirWorkoutPath => 'workout';
  String get dirProgramPath => 'program';
  String get dirDownloadPath => 'download';
  String get dirToolsPath => 'tools';
  String get dirLevelsPath => 'levels';
}
/// ----------------------------------------------------------------------------