import 'package:flutter/material.dart';

import '../../../../core/recently_viewed/recently_viewed_products_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/home_models.dart';
import 'product_card_large.dart';
import 'section_header.dart';

class RecentlyViewedProductsSection extends StatelessWidget {
  final ValueChanged<HomeProduct> onProductTap;

  const RecentlyViewedProductsSection({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: RecentlyViewedProductsService.changes,
      builder: (context, value, child) {
        return FutureBuilder<List<HomeProduct>>(
          future: RecentlyViewedProductsService.getRecentProducts(),
          builder: (context, snapshot) {
            final products = snapshot.data ?? const <HomeProduct>[];
            if (products.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: AppLocalizations.of(context)!.homeRecentlyViewedProducts),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth > 0
                        ? constraints.maxWidth
                        : MediaQuery.of(context).size.width;
                    final cardWidth = (screenWidth - 40 - 12) / 2;
                    final listHeight = cardWidth + 96;

                    return SizedBox(
                      height: listHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: products.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCardLarge(
                            key: ValueKey(
                              'recent_${product.numericId}_${product.urlKey}',
                            ),
                            product: product,
                            cardWidth: cardWidth,
                            showWishlistIcon: false,
                            onTap: () => onProductTap(product),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
