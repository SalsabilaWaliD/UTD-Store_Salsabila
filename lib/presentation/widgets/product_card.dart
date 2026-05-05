import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubits/bookmark/bookmark_cubit.dart';
import '../../../domain/entities/product_entity.dart';

class ProductCard extends StatefulWidget {
  final ProductEntity product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final result = await context.read<BookmarkCubit>().isBookmarked(widget.product.id);
    if (mounted) setState(() => _isBookmarked = result);
  }

  Future<void> _toggleBookmark() async {
    final cubit = context.read<BookmarkCubit>();
    if (_isBookmarked) {
      await cubit.removeBookmark(widget.product.id);
    } else {
      await cubit.addBookmark(widget.product);
    }
    setState(() => _isBookmarked = !_isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
                // Tombol Bookmark / Favorite
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.favorite : Icons.favorite_border,
                      color: _isBookmarked ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleBookmark,
                  ),
                ),
              ],
            ),
          ),

          // Info produk
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${(widget.product.price * 16000).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    Text(
                      ' ${widget.product.rating}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
