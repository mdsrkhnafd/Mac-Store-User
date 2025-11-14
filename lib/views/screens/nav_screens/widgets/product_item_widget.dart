import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/views/screens/detail/screen/product_detail_screen.dart';

import '../../../../provider/cart_provider.dart';
import '../../../../provider/favorite_provider.dart';
import '../../../../services/manage_http_response.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;
  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    ref.watch(favoriteProvider);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: widget.product),));
      },
      child: Container(
        height: 170,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(24)
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 2,
                    child: InkWell(
                      onTap: () {
                        favoriteProviderData.addProductToFavorite(
                          productName: widget.product.productName,
                          productPrice: widget.product.productPrice.toDouble(),
                          category: widget.product.category,
                          images: widget.product.images,
                          vendorId: widget.product.vendorId,
                          productQuantity: widget.product.quantity,
                          quantity: 1,
                          productId: widget.product.id,
                          description: widget.product.description,
                          fullName: widget.product.vendorFullName,
                        );

                        showSnackBar(context, widget.product.productName);
                      },
                      child: favoriteProviderData.getFavoriteItems
                          .containsKey(widget.product.id)
                          ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                          : Icon(Icons.favorite_border),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: isInCart
                          ? null
                          : () {
                        cartProviderData.addProductToCart(
                          productName: widget.product.productName,
                          productPrice: widget.product.productPrice.toDouble(),
                          category: widget.product.category,
                          images: widget.product.images,
                          vendorId: widget.product.vendorId,
                          productQuantity: widget.product.quantity,
                          quantity: 1,
                          productId: widget.product.id,
                          description: widget.product.description,
                          fullName: widget.product.vendorFullName,
                        );

                        showSnackBar(context, widget.product.productName);
                      },
                      child: Image.asset(
                        'assets/icons/cart.png',
                        width: 26,
                        height: 26,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Color(0xFF212121),
                fontWeight: FontWeight.bold
              ),
            ),
            widget.product.averageRating == 0
            ? const SizedBox()
            : Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 4,),
                Text(
                  widget.product.averageRating.toStringAsFixed(1),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                )
              ],
            ),
            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: Color(0xFF868D94),
              ),
            ),
            Text(
              '\$${widget.product.productPrice.toStringAsFixed(2)}',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
