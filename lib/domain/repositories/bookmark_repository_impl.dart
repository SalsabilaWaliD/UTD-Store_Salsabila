import '../../data/models/bookmark_item.dart'; // ✅ Import

class BookmarkRepositoryImpl implements BookmarkRepository {
  @override
  Stream<List<BookmarkItem>> watchBookmarks() {
    // ✅ Balikin BookmarkItem yang PUNYA savedAt
    return _bookmarkDao.watchAll().map((models) {
      return models.map((model) => BookmarkItem(
        product: model.toEntity(),
        savedAt: model.savedAt, // ✅ Ambil dari database
      )).toList();
    });
  }
  
  @override
  Future<void> addBookmark(ProductEntity product) async {
    final model = BookmarkModel(
      productId: product.id,
      productName: product.title,
      productPrice: product.price,
      productImage: product.image,
      savedAt: DateTime.now(), // ✅ Simpan timestamp saat ini
    );
    await _bookmarkDao.insert(model);
  }
  
  // ... method lain tetap sama
}