import 'package:isar/isar.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final Isar _isar;
  
  BookmarkRepositoryImpl(this._isar);
  
  @override
  Stream<List<ProductEntity>> watchBookmarks() {
    return _isar.bookmarkModels
        .where()
        .sortBySavedAtDesc() // Sort by newest first
        .watch(fireImmediately: true)
        .map((models) {
          return models.map((model) => ProductEntity(
            id: model.productId,
            title: model.productName,
            price: model.productPrice,
            description: '',
            category: '',
            image: model.productImage,
            rating: 0.0,
            ratingCount: 0,
          )).toList();
        });
  }
  
  @override
  Future<void> addBookmark(ProductEntity product) async {
    // Cek apakah sudah ada bookmark
    final existing = await _isar.bookmarkModels
        .where()
        .productIdEqualTo(product.id)
        .findFirst();
    
    if (existing != null) return; // Sudah ada, tidak usah tambah
    
    final bookmark = BookmarkModel.create(
      productId: product.id,
      productName: product.title,
      productPrice: product.price,
      productImage: product.image,
    );
    
    await _isar.writeTxn(() async {
      await _isar.bookmarkModels.put(bookmark);
    });
  }
  
  @override
  Future<void> removeBookmark(int productId) async {
    final bookmark = await _isar.bookmarkModels
        .where()
        .productIdEqualTo(productId)
        .findFirst();
    
    if (bookmark != null) {
      await _isar.writeTxn(() async {
        await _isar.bookmarkModels.delete(bookmark.id);
      });
    }
  }
  
  @override
  Future<bool> isBookmarked(int productId) async {
    final bookmark = await _isar.bookmarkModels
        .where()
        .productIdEqualTo(productId)
        .findFirst();
    return bookmark != null;
  }
}