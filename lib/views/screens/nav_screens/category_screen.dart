import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/header_widget.dart';

import '../../../controllers/category_controller.dart';
import '../../../models/category.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '/categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  // TODO: Add a variable to store the selected subcategory
  List<SubCategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureCategories = CategoryController().loadCategories();

    // once the categories are loaded process then
    futureCategories.then((categories) {
      // iterate through the categories to find "Fashion" category
      for (var category in categories) {
        if (category.name == "Fashion") {
          // if "Fashion" category is found, set it as selected category
          setState(() {
            _selectedCategory = category;
          });

          // load the subcategories for the "Fashion" category
          _loadSubCategories(category.name);
          break; // Add break here to stop after finding "Fashion"
        }
      }
    });
  }


  // this will load subcategories based on the categoryName
  Future<void> _loadSubCategories(String categoryName) async {
    try {
      final subcategories = await _subcategoryController.getSubCategoriesByCategoryName(categoryName);
      setState(() {
        _subcategories = subcategories;
      });
    } catch (e) {
      print('Error loading subcategories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20), child: HeaderWidget(),),

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //   TODO: Left side display categories
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if(snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _loadSubCategories(category.name);
                            },
                            title: Text(category.name ,
                              style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == category ? Colors.blue : Colors.black
                              ),
                            ),

                          );
                        },
                      );
                    }
                  },
              ),
            ),
          ),
        //   TODO: Right side display selected category details
          Expanded(
            flex: 5,
              child: _selectedCategory != null ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_selectedCategory!.name,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_selectedCategory!.banner),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    // TODO: Display subcategories
                    _subcategories.isNotEmpty ? GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: _subcategories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                         childAspectRatio: 2/3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 8
                        ),
                        itemBuilder: (context, index) {
                          final subcategory = _subcategories[index];
                          return SubcategoryTileWidget(image: subcategory.image, title: subcategory.subCategoryName);
                        },
                    )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('No subcategories available',
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                                              ),
                                            ),
                        )
                  ],
                ),
              ) : Container(),
          )
        ],
      ),

    );
  }
}
