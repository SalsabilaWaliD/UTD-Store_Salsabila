import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await _remoteDataSource.getProducts();

    // ── LOGIKA PERSONAL NIM 20123017 ────────────────────────
    // Digit terakhir NIM = 7 (GANJIL)
    // Wajib tambahkan "[Diskon 10%]" di belakang nama semua produk
    // Logika ini berada di layer Repository, BUKAN di Widget UI
    return models.map((product) {
      return _ProductEntityWithDiscount(
        id: product.id,
        title: '${product.title} [Diskon 10%]',
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rating: product.rating,
        ratingCount: product.ratingCount,
      );
    }).toList();
  }
}

/// Private helper class untuk manipulasi data di layer repository
class _ProductEntityWithDiscount extends ProductEntity {
  const _ProductEntityWithDiscount({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
    required super.ratingCount,
  });
}
