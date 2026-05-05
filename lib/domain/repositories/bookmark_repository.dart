import '../entities/product_entity.dart';

abstract class BookmarkRepository {
  Stream<List<ProductEntity>> watchBookmarks();
  Future<void> addBookmark(ProductEntity product);
  Future<void> removeBookmark(int productId);
  Future<bool> isBookmarked(int productId);
}
