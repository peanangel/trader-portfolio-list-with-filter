import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  /// ฟอร์แมตตัวเลขจำนวนเต็มมีคอมม่าคั่น เช่น 1000 -> "1,000"
  static String format(num value, {int decimalDigits = 0}) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    return formatter.format(value).trim();
  }

  /// ฟอร์แมตตัวเลขทางการเงิน เช่น 56592.5 -> "56,592.50"
  static String formatCurrency(
    num value, {
    int decimalDigits = 2,
    String symbol = '',
  }) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value).trim();
  }

  /// ฟอร์แมตเปอร์เซ็นต์ เช่น 17.07 -> "+17.07%"
  static String formatPercentage(
    num value, {
    int decimalDigits = 2,
    bool showPlusSign = true,
  }) {
    final sign = (showPlusSign && value > 0) ? '+' : '';
    final formatted = value.toStringAsFixed(decimalDigits);
    return '$sign$formatted%';
  }

  /// ฟอร์แมตแบบย่อ เช่น 1200000 -> "1.2M", 50000 -> "50K"
  static String formatCompact(num value) {
    return NumberFormat.compact(locale: 'en_US').format(value);
  }
}

/// Extension ช่วยให้เรียกใช้ง่ายขึ้นจากตัวเลขโดยตรง
/// ตัวอย่าง: 1000.toFormatted() -> "1,000"
/// ตัวอย่าง: trader.aum.toCurrency() -> "56,592.50"
extension NumberFormattingExtension on num {
  /// ตัวเลขคั่นหลักพัน เช่น 1000.toFormatted() -> "1,000"
  String toFormatted({int decimalDigits = 0}) {
    return NumberFormatter.format(this, decimalDigits: decimalDigits);
  }

  /// สกุลเงินทศนิยม 2 ตำแหน่ง เช่น 56592.5.toCurrency() -> "56,592.50"
  String toCurrency({int decimalDigits = 2, String symbol = ''}) {
    return NumberFormatter.formatCurrency(
      this,
      decimalDigits: decimalDigits,
      symbol: symbol,
    );
  }

  /// เปอร์เซ็นต์ เช่น 17.07.toPercentage() -> "+17.07%"
  String toPercentage({int decimalDigits = 2, bool showPlusSign = true}) {
    return NumberFormatter.formatPercentage(
      this,
      decimalDigits: decimalDigits,
      showPlusSign: showPlusSign,
    );
  }
}
