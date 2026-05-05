import 'package:isar/isar.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final Isar _isar;

  BookmarkRepositoryImpl(this._isar);

  @override
  Stream<List<ProductEntity>> watchBookmarks() {
    // Stream Reactive: menggunakan watch() dari Isar tanpa setState
    return _isar.bookmarkModels
        .where()
        .watch(fireImmediately: true)
        .map((bookmarks) => bookmarks.map(_toEntity).toList());
  }

  @override
  Future<void> addBookmark(ProductEntity product) async {
    await _isar.writeTxn(() async {
      final bookmark = BookmarkModel()
        ..productId = product.id
        ..title = product.title
        ..price = product.price
        ..description = product.description
        ..category = product.category
        ..image = product.image
        ..rating = product.rating
        ..ratingCount = product.ratingCount
        ..savedAt = DateTime.now(); // Timestamp saat tombol ditekan
      await _isar.bookmarkModels.put(bookmark);
    });
  }

  @override
  Future<void> removeBookmark(int productId) async {
    await _isar.writeTxn(() async {
      final bookmark = await _isar.bookmarkModels
          .filter()
          .productIdEqualTo(productId)
          .findFirst();
      if (bookmark != null) {
        await _isar.bookmarkModels.delete(bookmark.id);
      }
    });
  }

  @override
  Future<bool> isBookmarked(int productId) async {
    final bookmark = await _isar.bookmarkModels
        .filter()
        .productIdEqualTo(productId)
        .findFirst();
    return bookmark != null;
  }

  ProductEntity _toEntity(BookmarkModel model) {
    return _BookmarkProductEntity(
      id: model.productId,
      title: model.title,
      price: model.price,
      description: model.description,
      category: model.category,
      image: model.image,
      rating: model.rating,
      ratingCount: model.ratingCount,
      savedAt: model.savedAt,
    );
  }
}

class _BookmarkProductEntity extends ProductEntity {
  final DateTime savedAt;

  const _BookmarkProductEntity({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
    required super.ratingCount,
    required this.savedAt,
  });
}
