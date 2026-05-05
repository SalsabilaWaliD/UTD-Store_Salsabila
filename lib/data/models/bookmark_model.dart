import 'package:isar/isar.dart';

part 'bookmark_model.g.dart';

@collection
class BookmarkModel {
  Id id = Isar.autoIncrement;
  
  late int productId;
  late String productName;
  late double productPrice;
  late String productImage;
  late DateTime savedAt; // ✅ WAJIB ADA untuk timestamp
  
  BookmarkModel();
  
  // Constructor untuk membuat bookmark baru
  BookmarkModel.create({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  }) {
    savedAt = DateTime.now(); // ✅ Otomatis terisi
  }
}