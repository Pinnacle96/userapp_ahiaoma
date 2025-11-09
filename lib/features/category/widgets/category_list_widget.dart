import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return Column(children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraSmall),
            child: TitleRowWidget(
              title: getTranslated('CATEGORY', context),
              onTap: () {
                if(categoryProvider.categoryList.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()));
                }
              },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          categoryProvider.categoryList.isNotEmpty ?
          _RedesignedCategoryGrid(categoryProvider: categoryProvider) : const CategoryShimmerWidget(),
        ]);

      },
    );
  }
}

class _RedesignedCategoryGrid extends StatelessWidget {
  final CategoryController categoryProvider;
  const _RedesignedCategoryGrid({required this.categoryProvider});

  @override
  Widget build(BuildContext context) {
    // Build a list of up to 8 entries: categories, and if few, include subcategories.
    final List<_CategoryEntry> entries = [];
    final List<CategoryModel> categories = categoryProvider.categoryList;

    for (final cat in categories) {
      if (entries.length >= 8) break;
      entries.add(_CategoryEntry(
        id: cat.id,
        name: cat.name ?? '',
        imageUrl: cat.imageFullUrl?.path ?? '',
        categoryModel: cat,
      ));
    }

    // If categories are fewer than 8, fill with subcategories
    if (entries.length < 8) {
      for (final cat in categories) {
        if (entries.length >= 8) break;
        final subs = cat.subCategories ?? [];
          for (final sub in subs) {
            if (entries.length >= 8) break;
            entries.add(_CategoryEntry(
              id: sub.id,
              name: sub.name ?? '',
            imageUrl: cat.imageFullUrl?.path ?? '',
              subCategory: sub,
              categoryModel: cat,
            ));
          }
        }
    }

    return Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: GridView.builder(
          itemCount: entries.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final e = entries[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: e.id,
                      name: e.name,
                      subCategory: e.subCategory,
                      categoryModel: e.categoryModel,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .12), width: .5),
                      color: Theme.of(context).highlightColor,
                    ),
                    child: CustomImageWidget(
                      image: e.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.40),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall,
                    child: Text(
                      e.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()));
            },
            child: Text(
              getTranslated('see_all', context) ?? 'See All',
              style: textBold.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _CategoryEntry {
  final int? id;
  final String name;
  final String imageUrl;
  final SubCategory? subCategory;
  final CategoryModel? categoryModel;
  _CategoryEntry({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subCategory,
    this.categoryModel,
  });
}



