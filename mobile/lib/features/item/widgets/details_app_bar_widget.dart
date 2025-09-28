import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DetailsAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const DetailsAppBarWidget({super.key});

  @override
  DetailsAppBarWidgetState createState() => DetailsAppBarWidgetState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class DetailsAppBarWidgetState extends State<DetailsAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge!.color), onPressed: () => Navigator.pop(context)),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      title: Text(
        'item_details'.tr,
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
      centerTitle: true,
      actions: [],
    );
  }
}
