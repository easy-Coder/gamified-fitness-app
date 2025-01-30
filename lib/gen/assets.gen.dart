/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/chicken_skewers.jpg
  AssetGenImage get chickenSkewers =>
      const AssetGenImage('assets/images/chicken_skewers.jpg');

  /// File path: assets/images/man_workingout.png
  AssetGenImage get manWorkingout =>
      const AssetGenImage('assets/images/man_workingout.png');

  /// List of all assets
  List<AssetGenImage> get values => [chickenSkewers, manWorkingout];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/logo.jpeg
  AssetGenImage get logo => const AssetGenImage('assets/logo/logo.jpeg');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class $AssetsRiveGen {
  const $AssetsRiveGen();

  /// File path: assets/rive/water_cup.riv
  String get waterCup => 'assets/rive/water_cup.riv';

  /// List of all assets
  List<String> get values => [waterCup];
}

class $AssetsWelcomeGen {
  const $AssetsWelcomeGen();

  /// File path: assets/welcome/welcome.mp4
  String get welcome => 'assets/welcome/welcome.mp4';

  /// List of all assets
  List<String> get values => [welcome];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
  static const $AssetsRiveGen rive = $AssetsRiveGen();
  static const $AssetsWelcomeGen welcome = $AssetsWelcomeGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
