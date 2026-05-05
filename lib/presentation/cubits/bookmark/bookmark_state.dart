part of 'bookmark_cubit.dart';

abstract class BookmarkState extends Equatable {}

class BookmarkInitial extends BookmarkState {
  @override
  List<Object?> get props => [];
}

class BookmarkLoaded extends BookmarkState {
  final List<ProductEntity> bookmarks;
  BookmarkLoaded(this.bookmarks);
  
  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkError extends BookmarkState {
  final String message;
  BookmarkError(this.message);
  
  @override
  List<Object?> get props => [message];
}