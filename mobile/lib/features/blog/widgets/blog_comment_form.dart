import 'package:flutter/material.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:get/get.dart';

class BlogCommentForm extends StatefulWidget {
  final int postId;
  final Function(BlogCommentModel) onSubmit;

  const BlogCommentForm({
    super.key,
    required this.postId,
    required this.onSubmit,
  });

  @override
  State<BlogCommentForm> createState() => _BlogCommentFormState();
}

class _BlogCommentFormState extends State<BlogCommentForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_formKey.currentState!.validate()) {
      BlogCommentModel comment = BlogCommentModel(
        postId: widget.postId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        comment: _commentController.text.trim(),
        isApproved: false,
        isSpam: false,
      );
      
      widget.onSubmit(comment);
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).disabledColor.withOpacity(0.2),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave a Comment',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            
            const SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: robotoRegular.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: robotoRegular.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Comment Field
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: robotoRegular.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your comment';
                }
                return null;
              },
            ),
            
            const SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                ),
                child: Text(
                  'Submit Comment',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
