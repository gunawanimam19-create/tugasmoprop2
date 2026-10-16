import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import 'menu_detail_sheet.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;
  final bool isHorizontalCompact;

  const MenuCard({
    super.key,
    required this.item,
    this.isHorizontalCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isHorizontalCompact) {
      return Container(
        width: 190,
        margin: const EdgeInsets.only(right: 14),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => MenuDetailSheet.show(context, item),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image & Badges
                Stack(
                  children: [
                    Image.network(
                      item.imageUrl,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 110,
                        color: isDark ? Colors.grey[800] : const Color(0xFFFFE0B2),
                        child: const Center(
                          child: Icon(Icons.lunch_dining_rounded, color: AppTheme.primaryOrange, size: 36),
                        ),
                      ),
                    ),
                    if (item.isPromo)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${item.discountPercent}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${item.rating}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              AppTheme.formatRupiah(item.discountedPrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // List Style Card
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => MenuDetailSheet.show(context, item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.imageUrl,
                      width: 95,
                      height: 95,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 95,
                        height: 95,
                        color: isDark ? Colors.grey[800] : const Color(0xFFFFE0B2),
                        child: const Icon(Icons.fastfood, color: AppTheme.primaryOrange, size: 32),
                      ),
                    ),
                  ),
                  if (item.isPromo)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${item.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (item.isPopular)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Favorit',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          '${item.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (item.isPromo)
                                Text(
                                  AppTheme.formatRupiah(item.price),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                AppTheme.formatRupiah(item.discountedPrice),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
