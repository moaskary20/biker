import 'package:flutter/material.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';
import 'package:sixam_mart/features/blog/widgets/blog_category_card.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BlogCategoryChips extends StatelessWidget {
  final List<BlogCategoryModel> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const BlogCategoryChips({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" option
            bool isSelected = selectedCategoryId == null;
            return Padding(
              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: InkWell(
                onTap: () => onCategorySelected(null),
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Theme.of(context).disabledColor.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apps,
                        size: 40,
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All',
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: isSelected 
                              ? Theme.of(context).primaryColor 
                              : Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          final category = categories[index - 1];
          bool isSelected = selectedCategoryId == category.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: BlogCategoryCard(
              category: category,
              isSelected: isSelected,
              onTap: () => onCategorySelected(category.id),
            ),
          );
        },
      ),
    );
  }
}
