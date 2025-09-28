import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';

class BlogImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imageFullUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCategory;

  const BlogImageWidget({
    super.key,
    this.imageUrl,
    this.imageFullUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withOpacity(0.1),
        ),
        child: (imageFullUrl != null && imageFullUrl!.isNotEmpty) || (imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
                imageFullUrl ?? imageUrl!,
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultImage(context);
                },
              )
            : _buildDefaultImage(context),
      ),
    );
  }

  Widget _buildDefaultImage(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCategory
              ? [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ]
              : [
                  Theme.of(context).disabledColor.withOpacity(0.1),
                  Theme.of(context).disabledColor.withOpacity(0.05),
                ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCategory ? Icons.category : Icons.article,
              size: (height ?? 120) * 0.3,
              color: isCategory
                  ? Theme.of(context).primaryColor.withOpacity(0.6)
                  : Theme.of(context).disabledColor.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            Text(
              isCategory ? 'Category' : 'Blog Post',
              style: TextStyle(
                fontSize: (height ?? 120) * 0.08,
                color: isCategory
                    ? Theme.of(context).primaryColor.withOpacity(0.6)
                    : Theme.of(context).disabledColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

