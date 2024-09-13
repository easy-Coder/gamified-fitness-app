import 'package:flutter/material.dart';

@immutable
class Emoji {
  final String background;
  final String face;
  final String outfit;
  final String eyes;
  final String mouth;
  final String hair;
  final String accessories;

  const Emoji({
    required this.background,
    required this.face,
    required this.outfit,
    required this.eyes,
    required this.mouth,
    required this.hair,
    required this.accessories,
  });

  Emoji copyWith({
    String? background,
    String? face,
    String? outfit,
    String? eyes,
    String? mouth,
    String? hair,
    String? accessories,
  }) {
    return Emoji(
      background: background ?? this.background,
      face: face ?? this.face,
      outfit: outfit ?? this.outfit,
      eyes: eyes ?? this.eyes,
      mouth: mouth ?? this.mouth,
      hair: hair ?? this.hair,
      accessories: accessories ?? this.accessories,
    );
  }

  @override
  String toString() {
    return '''
      <svg width="1300" height="1300" viewBox="0 0 1300 1300" fill="none" xmlns="http://www.w3.org/2000/svg">
        <g id="Cute Avatar">
          <g id="Background">
            $background
          </g>
          <mask id="mask0_26_635" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="1301" height="1300">
            <path id="Masking" d="M650 1300C290.71 1300 0 1008.86 0 650C0 290.71 291.141 0 650 0C1009.29 0 1300 291.141 1300 650C1300.43 1009.29 1009.29 1300 650 1300Z" fill="#F7C0B5"/>
          </mask>
          <g mask="url(#mask0_26_635)">
            <g id="Face">
              $face
            </g>
            <g id="Outfit">
              $outfit
            </g>
            <g id="Eyes">
              $eyes
            </g>
            <g id="Mouth">
              $mouth
            </g>
            <g id="Hair">
              $hair
            </g>
            <g id="Accessories">
              $accessories
            </g>
          </g>
        </g>
    </svg>
''';
  }
}
