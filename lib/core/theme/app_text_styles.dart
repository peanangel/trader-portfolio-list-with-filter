import 'package:flutter/material.dart';

class AppTextStyles {
  /// หัวข้อขนาดใหญ่ (เช่น Spot Copy Trading)
  static const headingLG = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
  );

  /// หัวข้อขนาดกลาง (เช่น Advanced Filters)
  static const headingMD = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.5,
  );

  /// ข้อความเนื้อหาหลัก ตัวหนา (เช่น ชื่อ Trader, หัวข้อ Tags)
  static const bodyLG = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.5,
  );

  /// ข้อความเนื้อหาขนาดเล็ก (12px)
  static const bodySM = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.5,
  );

  /// คำอธิบายย่อย (10px)
  static const caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.4,
  );
}
