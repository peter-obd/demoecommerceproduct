import 'package:carousel_slider/carousel_slider.dart';
import 'package:demoecommerceproduct/controllers/product_details_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product/product_variant_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductItem product;
  final bool? isFromFavorites;
  const ProductDetailsScreen(
      {super.key, required this.product, this.isFromFavorites});

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
  bool _isFavorite = false;
  bool _isLoading = false;

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

    // Initialize favorite state
    _isFavorite = widget.product.isFavorite ?? false;

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
      _currentImages =
          widget.product.thumbnail != null ? [widget.product.thumbnail!] : [];
    }

    // Initialize available attributes for all attribute types
    final allAttributeNames = _getAllAttributeNames();
    for (final attributeName in allAttributeNames) {
      _availableAttributes[attributeName] =
          _getAvailableValuesForAttribute(attributeName);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    controller.isLoading.value = true;
    try {
      // Get current user
      final currentUser = await IsarService.instance.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
        });
        controller.isLoading.value = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to add favorites'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading state
      // setState(() {
      //   _isFavorite = !_isFavorite;
      // });

      // Call API to add/remove from favorites
      // Note: Current API only supports productId and userId
      // In future, consider adding variantId to track specific variant favorites
      _isFavorite == true
          ? ApisService.toggleFavoriteProduct(
              widget.product.id,
              false,
              (success) {
                if (success) {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  setState(() {
                    _isLoading = false;
                  });
                  controller.isLoading.value = false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Added to favorites!'
                            : 'Removed from favorites!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Update product model locally
                  widget.product.isFavorite = _isFavorite;
                  IsarService.instance.updateProductIsFavoriteById(
                      widget.product.id, _isFavorite);
                } else {
                  // Revert state if API call failed
                  setState(() {
                    _isLoading = false;
                  });
                  controller.isLoading.value = false;

                  // setState(() {
                  //   _isFavorite = !_isFavorite;
                  // });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update favorites'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              (error) {
                // Revert state if API call failed
                setState(() {
                  _isLoading = false;
                });
                controller.isLoading.value = false;

                // setState(() {
                //   _isFavorite = !_isFavorite;
                // });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            )
          : ApisService.toggleFavoriteProduct(
              widget.product.id,
              true,
              // "1",

              (success) {
                if (success) {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  setState(() {
                    _isLoading = false;
                  });
                  controller.isLoading.value = false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Added to favorites!'
                            : 'Removed from favorites!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Update product model locally
                  widget.product.isFavorite = _isFavorite;
                  IsarService.instance.updateProductIsFavoriteById(
                      widget.product.id, _isFavorite);
                } else {
                  // Revert state if API call failed
                  setState(() {
                    _isLoading = false;
                  });
                  controller.isLoading.value = false;

                  // setState(() {
                  //   _isFavorite = !_isFavorite;
                  // });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update favorites'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              (error) {
                // Revert state if API call failed
                setState(() {
                  _isLoading = false;
                });
                controller.isLoading.value = false;

                // setState(() {
                //   _isFavorite = !_isFavorite;
                // });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
    } catch (e) {
      // Revert state if error occurred
      setState(() {
        _isLoading = false;
      });
      controller.isLoading.value = false;

      // setState(() {
      //   _isFavorite = !_isFavorite;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
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

  Widget _buildEnhancedColorWidget(
      String colorHex, bool isSelected, Responsive responsive) {
    final color = hexToColor(colorHex);
    return Container(
      margin: EdgeInsets.only(right: responsive.wp(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: responsive.wp(50),
        height: responsive.hp(50),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 8,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(responsive.wp(4)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: color == const Color(0xffffffff)
                ? Border.all(color: Colors.black26, width: 1)
                : null,
          ),
          child: isSelected
              ? Icon(
                  Icons.check_rounded,
                  color: color == const Color(0xffffffff)
                      ? Colors.black
                      : Colors.white,
                  size: responsive.sp(35),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildEnhancedTextWidget(
      String value, bool isSelected, Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(right: responsive.wp(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(20),
          vertical: responsive.hp(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.greyShadow.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 6,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Text(
          value,
          style: AppTextStyle.textStyle(
            responsive.sp(32),
            isSelected ? Colors.white : AppColors.blackText,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.greyBackground,
          appBar: _buildEnhancedAppBar(responsive, context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Enhanced Image Carousel Section
                _buildEnhancedImageCarousel(responsive),

                // Enhanced Product Details Section
                _buildEnhancedProductDetails(responsive),
              ],
            ),
          ),
        ),
        // Enhanced Loading Overlay
        Obx(() => controller.isLoading.value == true
            ? Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(responsive.wp(40)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: responsive.hp(15)),
                        Text(
                          'Processing...',
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            AppColors.blackText,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container())
      ],
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar(
      Responsive responsive, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.only(left: responsive.wp(15)),
        child: GestureDetector(
          onTap: () {
            if (widget.isFromFavorites == true) {
              Get.back(result: true);
            } else {
              Get.back();
            }
          },
          child: Container(
            padding: EdgeInsets.all(responsive.wp(8)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.blackText,
              size: responsive.sp(40),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: responsive.wp(15)),
          child: GestureDetector(
            onTap: () => _toggleFavorite(),
            child: Container(
              padding: EdgeInsets.all(responsive.wp(8)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  key: ValueKey(_isFavorite),
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: _isFavorite ? Colors.red : AppColors.blackText,
                  size: responsive.sp(40),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedImageCarousel(Responsive responsive) {
    return Container(
      height: responsive.hp(350),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.greyBackground,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: _currentImages.map((imgUrl) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsive.wp(10),
                    vertical: responsive.hp(20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Padding(
                      padding: EdgeInsets.all(responsive.wp(20)),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: responsive.sp(100),
                                  color: AppColors.greyText,
                                ),
                                SizedBox(height: responsive.hp(10)),
                                Text(
                                  'Image not available',
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(28),
                                    AppColors.greyText,
                                    FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: _currentImages.length > 1,
                height: responsive.hp(300),
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),
          // Enhanced Page Indicators
          if (_currentImages.length > 1)
            Container(
              margin: EdgeInsets.only(bottom: responsive.hp(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_currentImages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
                    width: _currentIndex == index
                        ? responsive.wp(30)
                        : responsive.wp(15),
                    height: responsive.hp(8),
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.greyShadow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedProductDetails(Responsive responsive) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name with enhanced styling
            Text(
              widget.product.name,
              style: AppTextStyle.textStyle(
                responsive.sp(55),
                AppColors.blackText,
                FontWeight.w800,
              ),
            ),
            SizedBox(height: responsive.hp(10)),
// Enhanced Dynamic Attributes
            ..._availableAttributes.entries.map((attributeEntry) {
              final attributeName = attributeEntry.key;
              final availableValues = attributeEntry.value;

              if (availableValues.isEmpty) return const SizedBox();

              return _buildEnhancedAttributeSection(
                responsive,
                attributeName,
                availableValues,
              );
            }),
            // Price Section with enhanced styling
            _buildEnhancedPriceSection(responsive),

            SizedBox(height: responsive.hp(25)),

            // Stock Section with enhanced styling
            _buildEnhancedStockSection(responsive),

            SizedBox(height: responsive.hp(25)),

            SizedBox(height: responsive.hp(25)),

            // Enhanced Description Section
            _buildEnhancedDescriptionSection(responsive),

            SizedBox(height: responsive.hp(30)),

            // Enhanced Add to Basket Button
            _buildEnhancedAddToBasketButton(responsive),

            SizedBox(height: responsive.hp(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStockSection(Responsive responsive) {
    final stock = _selectedVariant.stock;
    final isOutOfStock = stock <= 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(20),
        vertical: responsive.hp(15),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOutOfStock
              ? [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.05),
                ]
              : stock <= 5
                  ? [
                      Colors.orange.withOpacity(0.1),
                      Colors.orange.withOpacity(0.05),
                    ]
                  : [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOutOfStock
              ? Colors.red.withOpacity(0.3)
              : stock <= 5
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stock Status",
                style: AppTextStyle.textStyle(
                  responsive.sp(32),
                  AppColors.greyText,
                  FontWeight.w500,
                ),
              ),
              SizedBox(height: responsive.hp(5)),
              Text(
                isOutOfStock
                    ? "Out of Stock"
                    : stock <= 5
                        ? "Low Stock ($stock left)"
                        : "$stock Available",
                style: AppTextStyle.textStyle(
                  responsive.sp(38),
                  isOutOfStock
                      ? Colors.red
                      : stock <= 5
                          ? Colors.orange
                          : Colors.green,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(responsive.wp(15)),
            decoration: BoxDecoration(
              color: isOutOfStock
                  ? Colors.red.withOpacity(0.2)
                  : stock <= 5
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isOutOfStock
                  ? Icons.inventory_2_outlined
                  : stock <= 5
                      ? Icons.warning_rounded
                      : Icons.check_circle_rounded,
              color: isOutOfStock
                  ? Colors.red
                  : stock <= 5
                      ? Colors.orange
                      : Colors.green,
              size: responsive.sp(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPriceSection(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(20),
        vertical: responsive.hp(15),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.lightBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price",
                style: AppTextStyle.textStyle(
                  responsive.sp(32),
                  AppColors.greyText,
                  FontWeight.w500,
                ),
              ),
              SizedBox(height: responsive.hp(5)),
              Text(
                "\$${widget.product.sellingPrice.toStringAsFixed(2)}",
                style: AppTextStyle.textStyle(
                  responsive.sp(50),
                  AppColors.primary,
                  FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(responsive.wp(15)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.local_offer_rounded,
              color: AppColors.primary,
              size: responsive.sp(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAttributeSection(
    Responsive responsive,
    String attributeName,
    List<String> availableValues,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attributeName,
            style: AppTextStyle.textStyle(
              responsive.sp(40),
              AppColors.blackText,
              FontWeight.w700,
            ),
          ),
          SizedBox(height: responsive.hp(15)),
          SizedBox(
            height: responsive.hp(50),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableValues.length,
              itemBuilder: (context, index) {
                final value = availableValues[index];
                final isSelected = _selectedAttributes[attributeName] == value;
                final shouldRenderAsColor =
                    _shouldRenderAsColor(attributeName, value);

                return GestureDetector(
                  onTap: () => _updateVariant(
                    attributeName: attributeName,
                    value: value,
                  ),
                  child: shouldRenderAsColor
                      ? _buildEnhancedColorWidget(value, isSelected, responsive)
                      : _buildEnhancedTextWidget(value, isSelected, responsive),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDescriptionSection(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: AppTextStyle.textStyle(
            responsive.sp(40),
            AppColors.blackText,
            FontWeight.w700,
          ),
        ),
        SizedBox(height: responsive.hp(15)),
        Container(
          padding: EdgeInsets.all(responsive.wp(20)),
          decoration: BoxDecoration(
            color: AppColors.greyBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.textStyle(
                  responsive.sp(35),
                  AppColors.greyText,
                  FontWeight.w400,
                ),
              ),
              _buildEnhancedFullDescriptionButton(responsive),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedAddToBasketButton(Responsive responsive) {
    final stock = _selectedVariant.stock;
    final isOutOfStock = stock <= 0;

    return Container(
      width: double.infinity,
      height: responsive.hp(70),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOutOfStock
              ? [
                  AppColors.greyShadow,
                  AppColors.greyShadow.withOpacity(0.8),
                ]
              : [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isOutOfStock
                ? AppColors.greyShadow.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isOutOfStock
            ? null
            : () async {
                controller.addToBasket(
                  widget.product.name,
                  widget.product.sellingPrice,
                  widget.product.thumbnail,
                  widget.product.id,
                  _selectedVariant.id,
                  context,
                  variantImage: _selectedVariant.images.isNotEmpty
                      ? _selectedVariant.images.first
                      : null,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBackgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOutOfStock ? Icons.block_rounded : Icons.shopping_cart_rounded,
              color: isOutOfStock ? AppColors.greyText : Colors.white,
              size: responsive.sp(45),
            ),
            SizedBox(width: responsive.wp(15)),
            Text(
              isOutOfStock ? 'Out of Stock' : 'Add to Basket',
              style: AppTextStyle.textStyle(
                responsive.sp(42),
                isOutOfStock ? AppColors.greyText : Colors.white,
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFullDescriptionButton(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(15)),
      child: GestureDetector(
        onTap: () {
          Utils.showBottomSheet(context,
              title: "Description",
              text: widget.product.description,
              showButton: false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(20),
            vertical: responsive.hp(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.article_rounded,
                color: AppColors.primary,
                size: responsive.sp(35),
              ),
              SizedBox(width: responsive.wp(10)),
              Text(
                'Read Full Description',
                style: AppTextStyle.textStyle(
                  responsive.sp(32),
                  AppColors.primary,
                  FontWeight.w600,
                ),
              ),
              SizedBox(width: responsive.wp(8)),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: responsive.sp(35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
