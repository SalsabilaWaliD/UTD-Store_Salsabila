import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/bookmark_repository.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository _bookmarkRepository;
  StreamSubscription? _subscription;

  BookmarkCubit(this._bookmarkRepository) : super(BookmarkInitial());

  void watchBookmarks() {
    _subscription?.cancel();
    _subscription = _bookmarkRepository.watchBookmarks().listen(
      (bookmarks) => emit(BookmarkLoaded(bookmarks)),
      onError: (e) => emit(BookmarkError(e.toString())),
    );
  }

  Future<void> addBookmark(ProductEntity product) async {
    await _bookmarkRepository.addBookmark(product);
  }

  Future<void> removeBookmark(int productId) async {
    await _bookmarkRepository.removeBookmark(productId);
  }

  Future<bool> isBookmarked(int productId) {
    return _bookmarkRepository.isBookmarked(productId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}