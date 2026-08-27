import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/trader_model.dart';
import '../data/trader_repository.dart';
import 'tag_filter_utils.dart';

final allTradersProvider = FutureProvider<List<TraderModel>>((ref) async {
  final traderRepository = TraderRepository();
  return await traderRepository.getTraders();
});

final availableTagsProvider = Provider<List<String>>((ref) {
  return const [
    'Top Performer',
    'Money Maker',
    'Whale Manager',
    'Most Resilient',
    'Solid Growth',
    'Most Consistent',
    'Low Leverage',
    'High Risk',
  ];
});

class FilterTagsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // ค่าเริ่มต้นเป็น Set ว่าง (คือยังไม่ได้เลือกกรองอะไร = แสดงทั้งหมด)
    return const {};
  }

  // ฟังก์ชันสลับการเลือก Tag (ถ้ามีให้เอาออก ถ้าไม่มีให้เพิ่มเข้า)
  void toggleTag(String tag) => state = toggleTagInSet(state, tag);

  // ฟังก์ชันแทนที่ค่าทั้งหมด (ใช้ตอนกด Confirm จาก Bottom Sheet)
  void setTags(Set<String> tags) {
    state = Set.from(tags);
  }

  // ฟังก์ชันล้างค่ากลับเป็นค่าว่าง
  void reset() {
    state = const {};
  }
}

// ตัวแปร Provider ที่ Widget จะนำไป ref.watch
final filterTagsProvider = NotifierProvider<FilterTagsNotifier, Set<String>>(
  FilterTagsNotifier.new,
);

class DraftFilterTagsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return ref.watch(filterTagsProvider);
  }

  void toggleTag(String tag) => state = toggleTagInSet(state, tag);

  void reset() {
    state = const {};
  }

  // สั่งซิงค์ค่าใหม่เมื่อเปิด Bottom Sheet
  void syncFromApplied() {
    state = ref.read(filterTagsProvider);
  }
}

final draftFilterTagsProvider =
    NotifierProvider<DraftFilterTagsNotifier, Set<String>>(
      DraftFilterTagsNotifier.new,
    );

final filteredTradersProvider = Provider<AsyncValue<List<TraderModel>>>((ref) {
  final allTradersAsync = ref.watch(allTradersProvider);
  final selectedTags = ref.watch(filterTagsProvider);

  return allTradersAsync.whenData((traders) {
    // 1. ถ้าไม่ได้เลือก Tag ใดเลย ให้แสดงทั้งหมด
    if (selectedTags.isEmpty) {
      return traders;
    }
    // 2. ถ้ามีการเลือก Tag ให้คืนเฉพาะ Trader ที่มี Tag ตรงกับที่เลือก
    return traders.where((trader) {
      return selectedTags.any((tag) => trader.tags.contains(tag));
    }).toList();
  });
});

final filteredTraderCountProvider = Provider<int>((ref) {
  final filteredAsync = ref.watch(filteredTradersProvider);
  return filteredAsync.value?.length ?? 0;
});
