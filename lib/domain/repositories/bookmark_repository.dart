import '../../domain/entities/product_entity.dart';

abstract class BookmarkRepository {
  Stream<List<ProductEntity>> watchBookmarks(); // KEMBALI KE ProductEntity
  Future<void> addBookmark(ProductEntity product);
  Future<void> removeBookmark(int productId);
  Future<bool> isBookmarked(int productId);
}