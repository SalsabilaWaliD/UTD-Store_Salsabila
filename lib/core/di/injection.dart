import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/models/bookmark_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/splash_service.dart';
import '../../presentation/cubits/product/product_cubit.dart';
import '../../presentation/cubits/bookmark/bookmark_cubit.dart';
import '../../presentation/cubits/crypto/crypto_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Isar Database ──────────────────────────────────────────
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [BookmarkModelSchema],
    directory: dir.path,
  );
  sl.registerSingleton<Isar>(isar);

  // ── Network ────────────────────────────────────────────────
  sl.registerSingleton<DioClient>(DioClient());

  // ── Data Sources ───────────────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<CryptoRemoteDataSource>(
    () => CryptoRemoteDataSourceImpl(),
  );

  // ── Repositories ───────────────────────────────────────────
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(sl<Isar>()),
  );

  // ── Use Cases / Services ───────────────────────────────────
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductRepository>()));

  // SplashService: delay logic based on NIM digit
  // NIM: 20123017 → last digit = 7 → delay 7 seconds
  sl.registerLazySingleton(() => SplashService(delaySeconds: 7));

  // ── Cubits ─────────────────────────────────────────────────
  sl.registerFactory(() => ProductCubit(sl<GetProductsUseCase>()));
  sl.registerFactory(() => BookmarkCubit(sl<BookmarkRepository>()));
  ssl.registerFactory(() => CryptoCubit(sl<CryptoRemoteDataSource>()));
}
