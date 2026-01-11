import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/constants.dart';

class QRGenerator {
  static Widget generateQR({
    String? data,
    double size = 200,
    Color foregroundColor = const Color(0xFF00FFD0),
    Color backgroundColor = const Color(0xFF050505),
  }) {
    return QrImageView(
      data: data ?? qrProveUrl,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foregroundColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
    );
  }
}
