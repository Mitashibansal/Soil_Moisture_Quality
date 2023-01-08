import 'dart:ui';
import 'package:flutter/widgets.dart';

/// A class to help you scale your design on bigger or smaller screens to achieve the same design look.
class Scale {
  static Size size = const Size(1280, 720);
  static Size _deviceScreenSize = const Size(1280, 720);
  static double _textScaleFactor = 1;

  static double get _horizontallyScaleFactor {
    return _deviceScreenSize.width / size.width;
  }

  static double get _verticallyScaleFactor {
    return _deviceScreenSize.height / size.height;
  }

  static double get _fontScaleFactor {
    return (_deviceScreenSize.width / size.width) * _textScaleFactor;
  }

  static double get _diagonalScaleFactor {
    return (_deviceScreenSize.width + _deviceScreenSize.height) /
        (size.width + size.height);
  }

  /// Setup the screen with a [context] and the [size] you will use.
  /// So, if you have a design with 1280 * 720. You will pass first the context
  /// then the design size.
  /// setup(context, Size(1280, 720))
  static void setup(BuildContext context, Size screenSize) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _deviceScreenSize = mediaQuery.size;
    size = screenSize;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  /// Setup the screen with the device screen [Size] and the [size] you will use.
  /// So, if you have a design with 1280 * 720. You will pass first the device
  /// screen size then the design size.
  /// setup(deviceScreenSize, Size(1280, 720))
  static void setupWith(Size deviceScreenSize, Size screenSize) {
    _deviceScreenSize = deviceScreenSize;
    size = screenSize;
  }

  /// Get the number scaled horizontally.
  static double scaleHorizontally(num number) {
    return number * _horizontallyScaleFactor;
  }

  /// Get the number scaled vertically.
  static double scaleVertically(num number) {
    return number * _verticallyScaleFactor;
  }

  /// Get the font scaled vertically.
  static double scaleFont(num number) {
    return number * _fontScaleFactor;
  }

  /// Get the font scaled vertically.
  static double scaleDiagonally(num number) {
    return number * _fontScaleFactor;
  }
}

/// An extension to make it easier to apply scale on number.
extension ScreenExtension on num {
  /// Get the number scaled horizontally.
  double get sw {
    return Scale.scaleHorizontally(this);
  }

  /// Get the number scaled vertically.
  double get sh {
    return Scale.scaleVertically(this);
  }

  /// Get the font scaled vertically.
  double get sf {
    return Scale.scaleFont(this);
  }

  double get sd {
    return Scale.scaleDiagonally(this);
  }
}
