part of 'book_details_cubit.dart';

enum BookDetailsStatus {loading, loaded, load_error}

class BookDetailsState extends Equatable {
  final BookDetailsStatus status;
  final bool loadedQuotes;
  final Book book;

  bool get loadedBook => book != null;

  const BookDetailsState._({
    this.status = BookDetailsStatus.loading,
    this.loadedQuotes = false,
    this.book,
  });

  const BookDetailsState.initial() : this._();

  BookDetailsState.loadedBook(Book b, {bool loadedQuotes = false}) : this._(
    status: BookDetailsStatus.loaded,
    book: b,
    loadedQuotes: loadedQuotes,
  );

  const BookDetailsState.error() : this._(status: BookDetailsStatus.load_error);

  @override
  List<Object> get props => [status, book, loadedQuotes];

  BookDetailsState copyWith({
    BookDetailsStatus status,
    Book book,
    bool loadedQuotes
  }) {
    return BookDetailsState._(
        status: status ?? this.status,
        book: book ?? this.book,
        loadedQuotes: loadedBook ?? this.loadedQuotes
    );
  }
}
