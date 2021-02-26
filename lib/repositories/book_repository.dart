import 'package:books/models/book.dart';
import 'package:books/models/quote.dart';

import 'data_providers/book_data_provider.dart';
import 'data_providers/quote_data_provider.dart';

class BookRepository {
  final BookDataProvider bookDataProvider = BookDataProvider();
  final QuoteDataProvider quoteDataProvider = QuoteDataProvider();

  Future<List<Book>> getInitialBooks() async {
    try {
      List<Map<String, dynamic>> rawBooks = await bookDataProvider.getRecentBooksByRating();
      List<Book> books = rawBooks.map((rawBook) => Book.fromMap(rawBook)).toList();

      return books;
    } catch(_) {
      return [];
    }
  }

  Future<List<Book>> loadBooksAfter(Book b, {int limit = 10}) async {
    try {
      List<Map<String, dynamic>> rawBooks = await bookDataProvider.getRecentBooksByRating(
        limit: limit,
        after: b.id,
      );
      List<Book> books = rawBooks.map((rawBook) => Book.fromMap(rawBook)).toList();

      return books;
    } catch(_) {
      return [];
    }
  }

  Future<Book> getBook(String bookId) async {
    try {
      Map<String, dynamic> rawBook = await bookDataProvider.getBook(bookId);
      return Book.fromMap(rawBook);
    } catch(_) {
      return null;
    }
  }

  Future<Book> getQuotesForBook(Book book) async {
    try {
      List<dynamic> rawQuotes = await quoteDataProvider.getQuotes(book.id);
      List<Quote> quotes = rawQuotes.map((e) => Quote.fromMap(e)).toList();
      return book.copyWith(
        quotes: quotes,
      );
    } catch(_) {
      return book;
    }
  }
}