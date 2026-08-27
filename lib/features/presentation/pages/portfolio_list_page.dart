import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_portfolio/core/utils/number_formatter.dart';
import 'package:trader_portfolio/features/presentation/widgets/filter_bottom_sheet.dart';
import 'package:trader_portfolio/features/providers/trader_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../data/models/trader_model.dart';

class PortfolioListPage extends ConsumerStatefulWidget {
  const PortfolioListPage({super.key});

  @override
  ConsumerState<PortfolioListPage> createState() => _PortfolioListPageState();
}

class _PortfolioListPageState extends ConsumerState<PortfolioListPage> {
  @override
  Widget build(BuildContext context) {
    final tradersAsync = ref.watch(filteredTradersProvider);
    final traderCount = ref.watch(filteredTraderCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Spot',
                  style: AppTextStyles.bodyLG.copyWith(
                    color: AppColors.iconPrimay,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: AppColors.iconPrimay,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.yellow500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.iconPrimay,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Be a Lead Trader',
                    style: AppTextStyles.bodyLG.copyWith(
                      color: AppColors.iconPrimay,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spot Copy Trading', style: AppTextStyles.headingLG),
            const SizedBox(height: 4),
            const Text(
              "Follow the world's top crypto traders and copy their trades with one click",
              style: TextStyle(color: AppColors.gray700, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FilterBottomSheet(),
                  ),
                  child: Badge(
                    label: Text(
                      traderCount > 99 ? '99+' : '$traderCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    backgroundColor: AppColors.yellow500,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: const Icon(Icons.filter_list, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            tradersAsync.when(
              loading: () {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('เกิดข้อผิดพลาด: $error'),
                  ),
                );
              },
              data: (List<TraderModel> data) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final trader = data[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [AppColors.yellow100, AppColors.white],
                        ),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  trader.avatarUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: AppColors.gray200,
                                        child: Icon(Icons.person),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trader.name,
                                      style: AppTextStyles.bodyLG,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,
                                          size: 14,
                                          color: AppColors.gray500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${trader.copierCount.toFormatted()}/${trader.copierLimit.toFormatted()}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.gray500,
                                          ),
                                        ),
                                        if (trader.isAPI) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.gray200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              "API",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          trader.pnl30d >= 0
                                              ? "+${trader.pnl30d.toCurrency()}"
                                              : "-${trader.pnl30d.abs().toCurrency()}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: trader.pnl30d >= 0
                                                ? AppColors.green500
                                                : AppColors.red500,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text.rich(
                                          TextSpan(
                                            text: 'ROI ',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.gray500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${trader.roi30d}%",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: trader.roi30d >= 0
                                                      ? AppColors.green500
                                                      : AppColors.red500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "AUM",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.gray500,
                                              ),
                                            ),
                                            Text(
                                              "\$${trader.aum.toCurrency()}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "30 Days MDD",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.gray500,
                                              ),
                                            ),
                                            Text(
                                              "${trader.mdd30d}%",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Sharpe Ratio",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.gray500,
                                              ),
                                            ),
                                            Text(
                                              "${trader.sharpeRatio}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: trader.tags
                                          .map(
                                            (tag) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.gray100,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: AppColors.gray200,
                                                ),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.gray700,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // ปุ่ม Mock และ Copy ล่างสุด
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gray200,
                                    foregroundColor: AppColors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Mock',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellow500,
                                    foregroundColor: AppColors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Copy',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
