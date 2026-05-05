import 'package:isar/isar.dart';

part 'bookmark_model.g.dart';

@Collection()
class BookmarkModel {
  Id id = Isar.autoIncrement;

  late int productId;
  late String title;
  late double price;
  late String description;
  late String category;
  late String image;
  late double rating;
  late int ratingCount;

  /// Timestamp wajib: waktu saat tombol bookmark ditekan
  /// Ditampilkan di UI Bookmark dengan format "Disimpan pada HH:mm"
  late DateTime savedAt;
}
