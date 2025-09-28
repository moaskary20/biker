import 'package:flutter/material.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';
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
      height: 40,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Theme.of(context).disabledColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'All',
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: isSelected 
                          ? Colors.white 
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            );
          }
          
          final category = categories[index - 1];
          bool isSelected = selectedCategoryId == category.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () => onCategorySelected(category.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).disabledColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  category.name ?? '',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: isSelected 
                        ? Colors.white 
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
