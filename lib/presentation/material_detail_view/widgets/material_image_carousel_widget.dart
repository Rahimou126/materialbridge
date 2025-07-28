import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class MaterialImageCarouselWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String materialName;

  const MaterialImageCarouselWidget({
    super.key,
    required this.imageUrls,
    required this.materialName,
  });

  @override
  State<MaterialImageCarouselWidget> createState() =>
      _MaterialImageCarouselWidgetState();
}

class _MaterialImageCarouselWidgetState
    extends State<MaterialImageCarouselWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300.h,
        width: double.infinity,
        child: Stack(children: [
          // Main image carousel
          PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      _showFullScreenImage(index);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface),
                        child: Hero(
                            tag: 'material_image_${widget.materialName}_$index',
                            child: CustomImageWidget(
                                imageUrl: widget.imageUrls[index],
                                height: 300.h,
                                width: double.infinity,
                                fit: BoxFit.cover))));
              }),
          // Page indicators
          if (widget.imageUrls.length > 1)
            Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        widget.imageUrls.length,
                        (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white.withAlpha(128)))))),
          // Thumbnail navigation
          if (widget.imageUrls.length > 1)
            Positioned(
                right: 16.w,
                top: 16.h,
                child: Container(
                    width: 60.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                        color: Colors.black.withAlpha(77),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: widget.imageUrls.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(index,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(4.w),
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            border: Border.all(
                                                color: _currentIndex == index
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.transparent,
                                                width: 2)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            child: CustomImageWidget(
                                                imageUrl:
                                                    widget.imageUrls[index],
                                                height: 40.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover))));
                              })),
                    ]))),
        ]));
  }

  void _showFullScreenImage(int initialIndex) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(children: [
              // Full screen image viewer
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: PageView.builder(
                      controller: PageController(initialPage: initialIndex),
                      itemCount: widget.imageUrls.length,
                      itemBuilder: (context, index) {
                        return InteractiveViewer(
                            panEnabled: true,
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Center(
                                child: CustomImageWidget(
                                    imageUrl: widget.imageUrls[index],
                                    fit: BoxFit.contain)));
                      })),
              // Close button
              Positioned(
                  top: 40.h,
                  right: 20.w,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          Icon(Icons.close, color: Colors.white, size: 28.sp))),
            ])));
  }
}
