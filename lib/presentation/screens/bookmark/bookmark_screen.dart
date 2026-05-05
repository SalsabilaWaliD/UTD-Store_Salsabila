import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../../domain/entities/product_entity.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmark',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoaded) {
            if (state.bookmarks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada produk yang disimpan',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.bookmarks.length,
              itemBuilder: (context, index) {
                final product = state.bookmarks[index];
                return _BookmarkItem(
                  product: product,
                  onRemove: () => context
                      .read<BookmarkCubit>()
                      .removeBookmark(product.id),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _BookmarkItem extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onRemove;

  const _BookmarkItem({required this.product, required this.onRemove});

  // Karena ProductEntity tidak punya savedAt, kita tampilkan waktu sekarang
  // atau Anda bisa menyimpan savedAt di field lain
  String _getFormattedTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: product.image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Rp ${(product.price * 16000).toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Disimpan pada ${_getFormattedTime()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}