import 'package:flutter/material.dart';

extension SizedboxExtension on num {
  SizedBox get sH => SizedBox(height: toDouble());
  SizedBox get sW => SizedBox(width: toDouble());
}
