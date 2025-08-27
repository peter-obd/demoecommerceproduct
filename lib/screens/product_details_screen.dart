// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:demoecommerceproduct/controllers/product_details_controller.dart';
// import 'package:demoecommerceproduct/models/product/product_model.dart';
// import 'package:demoecommerceproduct/models/product_model.dart';
// import 'package:demoecommerceproduct/utilities/Utils.dart';
// import 'package:demoecommerceproduct/values/colors.dart';
// import 'package:demoecommerceproduct/values/constants.dart';
// import 'package:demoecommerceproduct/values/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   final ProductItem product;
//   const ProductDetailsScreen({super.key, required this.product});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   final ProductDetailsController controller =
//       Get.put(ProductDetailsController());
//   final CarouselSliderController _carouselController =
//       CarouselSliderController();
//   int _currentIndex = 0;
//   Color hexToColor(String hex) {
//     hex = hex.replaceAll("#", "");
//     if (hex.length == 6) hex = "FF$hex"; // Add alpha if not present
//     return Color(int.parse(hex, radix: 16));
//   }

//   int _isSlected = 0;

//   @override
//   Widget build(BuildContext context) {
//     var responsive = Responsive(context);
//     return Scaffold(
//       backgroundColor: AppColors.greyBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.greyBackground,
//         leading: GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Image.asset("assets/icons/ArrowLeft.png")),
//         actions: [
//           Image.asset(
//             "assets/icons/Heart.png",
//             height: responsive.hp(22),
//           ),
//           SizedBox(width: responsive.wp(20)),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           width: double.infinity,
//           height: responsive.hp(720),
//           child: Column(
//             children: [
//               Expanded(
//                   flex: 3,
//                   child: SizedBox(
//                     child: Column(
//                       children: [
//                         CarouselSlider(
//                             items: List.generate(controller.images.length,
//                                 (index) {
//                               return Container(
//                                 margin:
//                                     EdgeInsets.only(bottom: responsive.hp(20)),
//                                 color: Colors.amber,
//                                 child: Image.asset(
//                                   controller.images[index],
//                                   fit: BoxFit.fill,
//                                 ),
//                               );
//                             }),
//                             carouselController: _carouselController,
//                             options: CarouselOptions(
//                               viewportFraction: 0.6,
//                               enlargeCenterPage: true,
//                               enableInfiniteScroll: false,
//                               height: responsive.hp(290),
//                               onPageChanged: (index, reason) {
//                                 setState(() {
//                                   _currentIndex = index;
//                                 });
//                               },
//                             )),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children:
//                               List.generate(controller.images.length, (index) {
//                             return _currentIndex == index
//                                 ? Container(
//                                     width: responsive
//                                         .wp(20), // adjust size as needed
//                                     height: responsive.hp(15),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: AppColors
//                                             .primary, // outer circle color
//                                         width: 1, // border thickness
//                                       ),
//                                     ),
//                                     // margin: EdgeInsets.only(
//                                     //   bottom: responsive.hp(4.25),
//                                     // ),
//                                     child: Center(
//                                       child: Container(
//                                         width: responsive.wp(7),
//                                         height: responsive.hp(7),
//                                         decoration: BoxDecoration(
//                                           color: AppColors
//                                               .primary, // inner circle color
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : Container(
//                                     margin: EdgeInsets.only(
//                                       left: responsive.wp(5),
//                                       right: responsive.wp(5),
//                                     ),
//                                     width: 8,
//                                     height: 8,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: AppColors.greyShadow),
//                                   );
//                           }),
//                         ),
//                       ],
//                     ),
//                   )),
//               Expanded(
//                   flex: 4,
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                         color: AppColors.secondary,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                         )),
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           left: responsive.wp(40),
//                           right: responsive.wp(40),
//                           top: responsive.hp(15)),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: double.infinity,
//                             child: Text(
//                               widget.product.name,
//                               overflow: TextOverflow.ellipsis,
//                               style: AppTextStyle.textStyle(responsive.sp(50),
//                                   AppColors.blackText, FontWeight.w600),
//                             ),
//                           ),
//                           SizedBox(
//                             height: responsive.hp(10),
//                           ),
//                           if (widget.product.attributes.isNotEmpty)
//                             for (var i = 0;
//                                 i < widget.product.attributes.length;
//                                 i++)
//                               widget.product.attributes[i]
//                                           .basicDataCategoryName ==
//                                       "Colors"
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Colors",
//                                           overflow: TextOverflow.ellipsis,
//                                           style: AppTextStyle.textStyle(
//                                               responsive.sp(35),
//                                               AppColors.blackText,
//                                               FontWeight.w600),
//                                         ),
//                                         SizedBox(
//                                           height: responsive.hp(10),
//                                         ),
//                                         SizedBox(
//                                             height: responsive.hp(40),
//                                             width: double.infinity,
//                                             child: ListView.builder(
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 itemCount: widget
//                                                     .product
//                                                     .attributes[i]
//                                                     .values
//                                                     .length,
//                                                 itemBuilder: (context, index) {
//                                                   final color = hexToColor(
//                                                       widget
//                                                           .product
//                                                           .attributes[i]
//                                                           .values[index]);
//                                                   return _isSlected == index
//                                                       ? Container(
//                                                           width: responsive.wp(
//                                                               35), // adjust size as needed
//                                                           height:
//                                                               responsive.hp(35),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                             border: Border.all(
//                                                               color: color ==
//                                                                       const Color(
//                                                                           0xffffffff)
//                                                                   ? Colors.black
//                                                                   : color,
//                                                               width: 1,
//                                                             ),
//                                                           ),
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                             right: responsive
//                                                                 .wp(10),
//                                                           ),
//                                                           child: Container(
//                                                             margin:
//                                                                 EdgeInsets.all(
//                                                                     responsive
//                                                                         .wp(3)),
//                                                             height: responsive
//                                                                 .hp(30),
//                                                             width: responsive
//                                                                 .wp(30),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                               color: color,
//                                                             ),
//                                                             alignment: Alignment
//                                                                 .center,
//                                                           ),
//                                                         )
//                                                       : GestureDetector(
//                                                           onTap: () {
//                                                             setState(() {
//                                                               _isSlected =
//                                                                   index;
//                                                             });
//                                                           },
//                                                           child: Container(
//                                                             margin: EdgeInsets.only(
//                                                                 right: responsive
//                                                                     .wp(10)),
//                                                             height: responsive
//                                                                 .hp(30),
//                                                             width: responsive
//                                                                 .wp(30),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                               color: color,
//                                                               border:
//                                                                   Border.all(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 width: 0.2,
//                                                               ),
//                                                             ),
//                                                             alignment: Alignment
//                                                                 .center,
//                                                           ),
//                                                         );
//                                                 }))
//                                       ],
//                                     )
//                                   : SizedBox(),
//                           SizedBox(
//                             height: responsive.hp(15),
//                           ),
//                           Text(
//                             "Description",
//                             overflow: TextOverflow.ellipsis,
//                             style: AppTextStyle.textStyle(responsive.sp(35),
//                                 AppColors.blackText, FontWeight.w600),
//                           ),
//                           SizedBox(
//                             height: responsive.hp(7),
//                           ),
//                           Text(
//                             widget.product.description,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: AppTextStyle.textStyle(responsive.sp(33),
//                                 AppColors.greyText, FontWeight.w400),
//                           ),
//                           _buildfullDescriptionButton(context),
//                           SizedBox(
//                             height: responsive.hp(15),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: responsive.hp(10)),
//                             width: double.infinity,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Total",
//                                   style: AppTextStyle.textStyle(
//                                       responsive.sp(38),
//                                       AppColors.blackText,
//                                       FontWeight.normal),
//                                 ),
//                                 Text("\$ ${widget.product.cost.toString()}",
//                                     style: AppTextStyle.textStyle(
//                                       responsive.sp(38),
//                                       AppColors.primary,
//                                       FontWeight.w600,
//                                     ))
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: responsive.hp(10),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: responsive.hp(10)),
//                             width: double.infinity,
//                             height: responsive.hp(55),
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: Text('Add to basket',
//                                   style: AppTextStyle.textStyle(
//                                       responsive.sp(37),
//                                       AppColors.secondary,
//                                       FontWeight.bold)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildfullDescriptionButton(BuildContext context) {
//     var responsive = Responsive(context);
//     return Container(
//       margin: EdgeInsets.only(top: responsive.hp(7)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Utils.showBottomSheet(context,
//                   title: "Description",
//                   text: widget.product.description,
//                   showButton: false);
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Full description',
//                     style: AppTextStyle.textStyle(
//                         responsive.sp(33), AppColors.primary, FontWeight.w600)),
//                 SizedBox(width: 8),
//                 Icon(
//                   Icons.arrow_forward,
//                   color: AppColors.primary,
//                   size: 20,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demoecommerceproduct/controllers/product_details_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product/product_variant_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductItem product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int _currentIndex = 0;
  late ProductVariant _selectedVariant;
  List<String> _currentImages = [];
  Map<String, String> _selectedAttributes = {};
  Map<String, List<String>> _availableAttributes = {};

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  bool _isColorAttribute(String attributeName) {
    return attributeName.toLowerCase().contains('color');
  }

  bool _isValidHexColor(String value) {
    final hexRegExp = RegExp(r'^#?[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$');
    return hexRegExp.hasMatch(value);
  }

  bool _shouldRenderAsColor(String attributeName, String value) {
    return _isColorAttribute(attributeName) && _isValidHexColor(value);
  }

  List<String> _getAllAttributeNames() {
    final Set<String> attributeNames = {};
    final allVariants = widget.product.allVariants;
    if (allVariants.isNotEmpty) {
      for (final variant in allVariants) {
        final attributes = variant.getAttributesValues();
        attributeNames.addAll(attributes.keys);
      }
    }
    return attributeNames.toList();
  }

  List<String> _getAvailableValuesForAttribute(String attributeName,
      {Map<String, String>? filterBy}) {
    final allVariants = widget.product.allVariants;
    if (allVariants.isEmpty) {
      return [];
    }
    return allVariants
        .where((variant) {
          if (filterBy == null) return true;
          final attributes = variant.getAttributesValues();
          return filterBy.entries
              .every((entry) => attributes[entry.key] == entry.value);
        })
        .map((variant) => variant.getAttributesValues()[attributeName])
        .whereType<String>()
        .toSet()
        .toList();
  }

  @override
  void initState() {
    super.initState();
    
    // Check if variants exist before accessing them
    final allVariants = widget.product.allVariants;
    if (allVariants.isNotEmpty) {
      _selectedVariant = allVariants.first;
      _selectedAttributes = _selectedVariant
          .getAttributesValues()
          .map((k, v) => MapEntry(k, v.toString()));
      _currentImages = _selectedVariant.images;
    } else {
      // Create a default variant if none exist
      _selectedVariant = ProductVariant.empty();
      _selectedAttributes = {};
      _currentImages = widget.product.thumbnail != null ? [widget.product.thumbnail!] : [];
    }

    // Initialize available attributes for all attribute types
    final allAttributeNames = _getAllAttributeNames();
    for (final attributeName in allAttributeNames) {
      _availableAttributes[attributeName] =
          _getAvailableValuesForAttribute(attributeName);
    }
  }

  void _updateVariant({String? attributeName, String? value}) {
    if (attributeName == null || value == null) return;
    final allVariants = widget.product.allVariants;
    if (allVariants.isEmpty) return;

    final newSelection = Map<String, String>.from(_selectedAttributes);
    newSelection[attributeName] = value;

    final match = allVariants.firstWhere(
      (variant) {
        final attributes = variant.getAttributesValues();
        return newSelection.entries
            .every((entry) => attributes[entry.key] == entry.value);
      },
      orElse: () {
        // fallback: find variant matching the new attribute only
        return allVariants.firstWhere(
          (variant) {
            final attributes = variant.getAttributesValues();
            return attributes[attributeName] == value;
          },
          orElse: () => _selectedVariant,
        );
      },
    );

    setState(() {
      _selectedVariant = match;
      _selectedAttributes =
          match.getAttributesValues().map((k, v) => MapEntry(k, v.toString()));
      _currentImages = match.images;

      // update available attributes based on current selection
      final allAttributeNames = _getAllAttributeNames();
      for (final attrName in allAttributeNames) {
        if (attrName != attributeName) {
          // Create a filter map excluding the current attribute being updated
          final filterMap = Map<String, String>.from(_selectedAttributes);
          filterMap.remove(attrName);
          _availableAttributes[attrName] =
              _getAvailableValuesForAttribute(attrName, filterBy: filterMap);
        }
      }
    });
  }

  Widget _buildColorWidget(
      String colorHex, bool isSelected, Responsive responsive) {
    final color = hexToColor(colorHex);
    return isSelected
        ? Container(
            width: responsive.wp(40),
            height: responsive.hp(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color == const Color(0xffffffff) ? Colors.black : color,
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(right: responsive.wp(10)),
            child: Container(
              margin: EdgeInsets.all(responsive.wp(3)),
              height: responsive.hp(30),
              width: responsive.wp(30),
              decoration: BoxDecoration(
                border: color == const Color(0xffffffff)
                    ? Border.all(color: Colors.black)
                    : null,
                shape: BoxShape.circle,
                color: color,
              ),
              alignment: Alignment.center,
            ),
          )
        : Container(
            margin: EdgeInsets.only(right: responsive.wp(10)),
            width: responsive.wp(35),
            height: responsive.hp(35),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border:
                  Border.all(color: Colors.black, width: isSelected ? 2 : 0.2),
            ),
          );
  }

  Widget _buildTextWidget(
      String value, bool isSelected, Responsive responsive) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: responsive.wp(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.greyShadow,
        border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyShadow),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.greyBackground,
          appBar: AppBar(
            backgroundColor: AppColors.greyBackground,
            leading: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset("assets/icons/ArrowLeft.png")),
            actions: [
              GestureDetector(
                  onTap: () {
                    controller.addProductToFavorites(
                        widget.product, "1", widget.product.id, context);
                  },
                  child: Obx(() => Image.asset("assets/icons/Heart.png",
                      color: widget.product.isFavorite ??
                              false || controller.isFavorite.value
                          ? Colors.red
                          : null,
                      height: responsive.hp(22)))),
              SizedBox(width: responsive.wp(20)),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: responsive.hp(290),
                  child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          items: _currentImages.map((imgUrl) {
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: responsive.hp(20)),
                              child: Image.network(imgUrl, fit: BoxFit.contain),
                            );
                          }).toList(),
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            viewportFraction: 0.6,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            height: responsive.hp(290),
                            onPageChanged: (index, reason) {
                              setState(() => _currentIndex = index);
                            },
                          ),
                        ),
                      ),
                      _currentImages.length > 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(_currentImages.length, (index) {
                                return _currentIndex == index
                                    ? Container(
                                        width: responsive.wp(20),
                                        height: responsive.hp(15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.primary),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: responsive.wp(7),
                                            height: responsive.hp(7),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(5)),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.greyShadow),
                                      );
                              }),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: responsive.wp(20)),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(40),
                        vertical: responsive.hp(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.textStyle(responsive.sp(50),
                                AppColors.blackText, FontWeight.w600)),
                        SizedBox(height: responsive.hp(10)),

                        // DYNAMIC ATTRIBUTES
                        ..._availableAttributes.entries.map((attributeEntry) {
                          final attributeName = attributeEntry.key;
                          final availableValues = attributeEntry.value;

                          if (availableValues.isEmpty) return const SizedBox();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: responsive.hp(10)),
                              Text(attributeName,
                                  style: AppTextStyle.textStyle(
                                      responsive.sp(35),
                                      AppColors.blackText,
                                      FontWeight.w600)),
                              SizedBox(height: responsive.hp(10)),
                              SizedBox(
                                height: responsive.hp(40),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: availableValues.length,
                                  itemBuilder: (context, index) {
                                    final value = availableValues[index];
                                    final isSelected =
                                        _selectedAttributes[attributeName] ==
                                            value;
                                    final shouldRenderAsColor =
                                        _shouldRenderAsColor(
                                            attributeName, value);

                                    return GestureDetector(
                                      onTap: () => _updateVariant(
                                        attributeName: attributeName,
                                        value: value,
                                      ),
                                      child: shouldRenderAsColor
                                          ? _buildColorWidget(
                                              value, isSelected, responsive)
                                          : _buildTextWidget(
                                              value, isSelected, responsive),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: responsive.hp(15)),
                        Text("Description",
                            style: AppTextStyle.textStyle(responsive.sp(35),
                                AppColors.blackText, FontWeight.w600)),
                        SizedBox(height: responsive.hp(7)),
                        Text(widget.product.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: AppTextStyle.textStyle(responsive.sp(33),
                                AppColors.greyText, FontWeight.w400)),
                        _buildfullDescriptionButton(context),
                        SizedBox(height: responsive.hp(15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: AppTextStyle.textStyle(responsive.sp(38),
                                    AppColors.blackText, FontWeight.normal)),
                            Text("\$ ${widget.product.cost.toString()}",
                                style: AppTextStyle.textStyle(responsive.sp(38),
                                    AppColors.primary, FontWeight.w600))
                          ],
                        ),
                        SizedBox(height: responsive.hp(10)),
                        SizedBox(
                          width: double.infinity,
                          height: responsive.hp(55),
                          child: ElevatedButton(
                            onPressed: () async {
                              controller.addToBasket(
                                  widget.product.name,
                                  widget.product.cost,
                                  widget.product.thumbnail,
                                  widget.product.id,
                                  _selectedVariant.id,
                                  context,
                                  variantImage: _selectedVariant.images.isNotEmpty ? _selectedVariant.images.first : null);
                              // await BasketService.instance
                              //     .addToBasket(CheckoutProduct(
                              //   productId: widget.product.id,
                              //   name: widget.product.name,
                              //   price: widget.product.cost,
                              //   imageUrl: widget.product.thumbnail ?? "",
                              //   quantity: 1,
                              // ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: Text('Add to basket',
                                style: AppTextStyle.textStyle(responsive.sp(37),
                                    AppColors.secondary, FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Obx(() => controller.isLoading.value == true
            ? Container(
                color: Colors.grey.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              )
            : Container())
      ],
    );
  }

  Widget _buildfullDescriptionButton(BuildContext context) {
    var responsive = Responsive(context);
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Utils.showBottomSheet(context,
                  title: "Description",
                  text: widget.product.description,
                  showButton: false);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Full description',
                    style: AppTextStyle.textStyle(
                        responsive.sp(33), AppColors.primary, FontWeight.w600)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
