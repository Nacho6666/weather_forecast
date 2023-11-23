import 'package:flutter/material.dart';

const preferenceVersion = '1.0.0';

enum EnvironmentType { prod, stage, uat, dev }

class Environment {
  final EnvironmentType type;
  final bool isDebugLogEnabled;
  static final instance = () {
    EnvironmentType type;
    switch (const String.fromEnvironment('env')) {
      case 'prod':
        type = EnvironmentType.prod;
        break;
      case 'stage':
        type = EnvironmentType.stage;
        break;
      case 'uat':
        type = EnvironmentType.uat;
        break;
      default:
        type = EnvironmentType.dev;
    }
    return Environment._(type, const int.fromEnvironment('debug-log', defaultValue: 1) == 1);
  }();

  Environment._(this.type, this.isDebugLogEnabled);
}

class ColorResource {
  static const main = Color(0xFF444444);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF222222);
  static const background = Color(0xFFF6F6F7);
  static const secondary = Color(0xFF808080);
  static const primary = Color(0xFF222222);
  static const blue = Color(0xFF0050B3);
  static const border = Color(0xFFD9D9D9);
  static const disable = Color(0xFFEEEEEF);
  static const errorBadge = Color(0xFFFF4D4F);
  static const error = Color(0xFFEF5533);
  static const link = Color(0xFF096DD9);
  static const redTag = Color(0xFFF6E1E1);
  static const grayTag = Color(0xFFDFDFDF);
  static const contactBackground = Color(0xFFC7C7C7);
  static const buttonContainer = Color(0xFF455A64);
}

class AppFont {
  static TextStyle tag({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0,
      fontFamily: 'NotoSans',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle body({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 16,
      height: 23 / 16,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle bodyH1({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 18,
      height: 26 / 18,
      letterSpacing: 0,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle title({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 16,
      height: 23 / 16,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w500,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle subtitle({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle actionSubtitle({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 16,
      height: 23 / 16,
      letterSpacing: -0.015,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle caption({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 12,
      height: 17 / 12,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle errorBadge({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 10,
      height: 14 / 10,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle titleLogin({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 20,
      height: 29 / 20,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle slogan({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 28,
      height: 40 / 28,
      letterSpacing: -0.0086,
      fontFamily: 'NotoSerifTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle bannerTitle({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 20,
      height: 24 / 20,
      letterSpacing: 0,
      fontFamily: 'NotoSerifTC',
      fontWeight: FontWeight.w700,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle h3({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 24,
      height: 35 / 24,
      letterSpacing: 0.1,
      fontFamily: 'NotoSansTC',
      fontWeight: FontWeight.w400,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }

  static TextStyle h4({Color? textColor, TextDecoration? textDecoration}) {
    return TextStyle(
      fontSize: 20,
      height: 29 / 20,
      letterSpacing: 0.1,
      fontFamily: 'NotoSerifTC',
      fontWeight: FontWeight.w600,
      color: textColor ?? ColorResource.black,
      decoration: textDecoration,
    );
  }
}
