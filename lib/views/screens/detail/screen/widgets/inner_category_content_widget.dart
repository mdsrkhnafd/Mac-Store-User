import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/inner_banner_widget.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/inner_header_widget.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

import '../../../../../models/category.dart';
import '../../../../../models/product.dart';
import '../../../../../models/subcategory.dart';
import '../../../nav_screens/widgets/product_item_widget.dart';


class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryContentWidget> {
  late Future<List<SubCategory>> _subCategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subCategories = _subcategoryController
        .getSubCategoriesByCategoryName(widget.category.name);
    futureProducts = ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20), child: InnerHeaderWidget()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text(
                'Shop By Category',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // FutureBuilder(
            //   future: _subCategories,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Error: ${snapshot.error}'),
            //       );
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return const Center(
            //         child: Text('No subcategories available'),
            //       );
            //     } else {
            //       final subcategories = snapshot.data!;
            //       return SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Column(
            //           children: List.generate((subcategories.length / 7).ceil(),
            //                   (setIndex) {
            //                 // for each row , calculate the starting and ending indices
            //                 final start = setIndex * 7;
            //                 final end = (setIndex + 1) * 7;
            //
            //                 // create a Padding widget to add spacing around the row
            //                 return Padding(
            //                   padding: const EdgeInsets.all(8.9),
            //                   child: Row(
            //                     children: subcategories
            //                         .sublist(
            //                       start,
            //                       end > subcategories.length
            //                           ? subcategories.length
            //                           : end,
            //                     )
            //                         .map((subcategory) => SubcategoryTileWidget(
            //                       image: subcategory.image,
            //                       title: subcategory.subCategoryName,
            //                     ))
            //                         .toList(), // 👈 convert Iterable<Widget> to List<Widget>
            //                   ),
            //                 );
            //               }),
            //         ),
            //       );
            //     }
            //   },
            // ),
          // Horizontal GridView for Subcategories (2 rows)
          FutureBuilder<List<SubCategory>>(
            future: _subCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No subcategories available'),
                );
              } else {
                final subcategories = snapshot.data!;
                return SizedBox(
                  height: 250, // Adjust the height as needed
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal, // Scroll horizontally
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 8.0, // Space between items horizontally
                      mainAxisSpacing: 8.0, // Space between rows vertically
                    ),
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
                    itemCount: subcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = subcategories[index];
                      return SubcategoryTileWidget(
                        image: subcategory.image,
                        title: subcategory.subCategoryName,
                      );
                    },
                  ),
                );
              }
            },
          ),

            const ReusableTextWidget(title: 'Popular Product', subtitle: "View all"),

            FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }
                else if (!snapshot.hasData || snapshot.data!.isEmpty){
                  return Center(
                    child: Text('No product this category'),
                  );
                }
                else {
                  final products = snapshot.data;
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: products!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItemWidget(product: product,);
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
