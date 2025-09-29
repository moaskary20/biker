import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/parcel/screens/parcel_request_screen.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class ParcelCategoryScreenRedesigned extends StatefulWidget {
  const ParcelCategoryScreenRedesigned({super.key});

  @override
  State<ParcelCategoryScreenRedesigned> createState() => _ParcelCategoryScreenRedesignedState();
}

class _ParcelCategoryScreenRedesignedState extends State<ParcelCategoryScreenRedesigned> {

  @override
  void initState() {
    super.initState();
    Get.find<LocationController>().getCurrentLocation(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'خدمات الطوارئ للدراجات'.tr),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.motorcycle,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(
                      'خدمات الطوارئ للدراجات',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      'اختر نوع الخدمة التي تحتاجها',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: Dimensions.paddingSizeLarge),
              
              // Service Categories
              Expanded(
                child: ListView(
                  children: [
                    // تعطل الدراجة (Breakdown)
                    _buildServiceCard(
                      context,
                      title: 'تعطل الدراجة (Breakdown)',
                      description: 'خدمة إصلاح الدراجات في حالة التعطل',
                      icon: Icons.build_circle,
                      color: Colors.red,
                      onTap: () => _navigateToRequestScreen(context, 'breakdown'),
                    ),
                    
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    
                    // حادث بسيط
                    _buildServiceCard(
                      context,
                      title: 'حادث بسيط',
                      description: 'خدمة المساعدة في الحوادث البسيطة',
                      icon: Icons.warning_amber_rounded,
                      color: Colors.orange,
                      onTap: () => _navigateToRequestScreen(context, 'accident'),
                    ),
                    
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    
                    // سحب الدراجة
                    _buildServiceCard(
                      context,
                      title: 'الحاجة إلى سحب الدراجة للمنزل أو الورشة',
                      description: 'خدمة سحب الدراجات للمنزل أو الورشة',
                      icon: Icons.local_shipping,
                      color: Colors.blue,
                      onTap: () => _navigateToRequestScreen(context, 'towing'),
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
  
  Widget _buildServiceCard(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    description,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToRequestScreen(BuildContext context, String serviceType) {
    Get.to(() => ParcelRequestScreen(serviceType: serviceType));
  }
}
