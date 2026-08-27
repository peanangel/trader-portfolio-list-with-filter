class TraderModel {
  final String id;
  final String name; // **
  final String avatarUrl; 
  final int copierCount;
  final int copierLimit;
  final bool isAPI;
  final List<String> tags;
  final double pnl30d; // **กำไร/ขาดทุนสุทธิใน 30 วัน (จำนวนเงิน)
  final double roi30d; // **ผลตอบแทน 30 วัน (%)
  final double aum; // **เงินทุนที่ trader บริหารอยู่ทั้งหมด (จำนวนเงิน)
  final double mdd30d; // **Maximum Drawdown ใน 30 วัน (%)
  final double sharpeRatio; // **ค่าตัวเลขวัดผลตอบแทนเทียบความเสี่ยง

  const TraderModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.copierCount,
    required this.copierLimit,
    required this.isAPI,
    required this.tags,
    required this.pnl30d,
    required this.roi30d,
    required this.aum,
    required this.mdd30d,
    required this.sharpeRatio,
  });

  factory TraderModel.fromJson(Map<String, dynamic> json) {
    return TraderModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      copierCount: json['copierCount'],
      copierLimit: json['copierLimit'],
      isAPI: json['isAPI'],
      tags: List<String>.from(json['tags']),
      pnl30d: json['pnl30d'].toDouble(),
      roi30d: json['roi30d'].toDouble(),
      aum: json['aum'].toDouble(),
      mdd30d: json['mdd30d'].toDouble(),
      sharpeRatio: json['sharpeRatio'].toDouble(),
    );
  }
}
