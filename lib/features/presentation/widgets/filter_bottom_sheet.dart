import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/trader_provider.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. อ่าน State จาก Riverpod
    final tags = ref.watch(availableTagsProvider);
    final selectedTags = ref.watch(draftFilterTagsProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Advanced Filters", style: AppTextStyles.headingMD),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.gray700,
                ),
                onPressed: () {
                  // ซิงค์ค่าดราฟต์กลับไปเป็นค่าจริงล่าสุดเมื่อปิดโดยไม่กด Confirm
                  ref.read(draftFilterTagsProvider.notifier).syncFromApplied();
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text("Tags", style: AppTextStyles.bodyLG),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.gray200),
          const SizedBox(height: 12),

          // 2. แตะชิป Tags -> ส่งคำสั่งไปที่ Notifier
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3.2,
            ),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              final isSelected = selectedTags.contains(tag);

              return FilterChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppColors.black : AppColors.gray700,
                    ),
                  ),
                ),
                selected: isSelected,
                showCheckmark: false,
                backgroundColor: AppColors.gray100,
                selectedColor: AppColors.yellow500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.yellow500 : AppColors.gray200,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onSelected: (_) {
                  ref.read(draftFilterTagsProvider.notifier).toggleTag(tag);
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // ปุ่ม Action ล่างสุด (Reset & Confirm)
          Row(
            children: [
              // 3. ปุ่ม Reset
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(filterTagsProvider.notifier).reset();
                    ref.read(draftFilterTagsProvider.notifier).reset();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray200,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 4. ปุ่ม Confirm
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final draft = ref.read(draftFilterTagsProvider);
                    ref.read(filterTagsProvider.notifier).setTags(draft);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow500,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
