/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/chicken_skewers.jpg
  AssetGenImage get chickenSkewers =>
      const AssetGenImage('assets/images/chicken_skewers.jpg');

  /// Directory path: assets/images/workouts
  $AssetsImagesWorkoutsGen get workouts => const $AssetsImagesWorkoutsGen();

  /// List of all assets
  List<AssetGenImage> get values => [chickenSkewers];
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

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/Empty.svg
  SvgGenImage get empty => const SvgGenImage('assets/svg/Empty.svg');

  /// File path: assets/svg/Search.svg
  SvgGenImage get search => const SvgGenImage('assets/svg/Search.svg');

  /// File path: assets/svg/flame.svg
  SvgGenImage get flame => const SvgGenImage('assets/svg/flame.svg');

  /// List of all assets
  List<SvgGenImage> get values => [empty, search, flame];
}

class $AssetsWelcomeGen {
  const $AssetsWelcomeGen();

  /// File path: assets/welcome/welcome.mp4
  String get welcome => 'assets/welcome/welcome.mp4';

  /// List of all assets
  List<String> get values => [welcome];
}

class $AssetsImagesWorkoutsGen {
  const $AssetsImagesWorkoutsGen();

  /// File path: assets/images/workouts/back.jpg
  AssetGenImage get back =>
      const AssetGenImage('assets/images/workouts/back.jpg');

  /// File path: assets/images/workouts/man_workingout.png
  AssetGenImage get manWorkingout =>
      const AssetGenImage('assets/images/workouts/man_workingout.png');

  /// File path: assets/images/workouts/running.jpg
  AssetGenImage get running =>
      const AssetGenImage('assets/images/workouts/running.jpg');

  /// File path: assets/images/workouts/upper_body.jpg
  AssetGenImage get upperBody =>
      const AssetGenImage('assets/images/workouts/upper_body.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [back, manWorkingout, running, upperBody];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
  static const $AssetsRiveGen rive = $AssetsRiveGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsWelcomeGen welcome = $AssetsWelcomeGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

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
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
