import 'package:books/models/book.dart';
import 'package:books/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookRepository _bookRepository;

  BookDetailsCubit({BookRepository bookRepository}) : _bookRepository = bookRepository ?? BookRepository(), super(BookDetailsState.initial());

  Future<void> loadBook({String id, Book cachedBook}) async {
    try {
      Book book;
      if(cachedBook != null) {
        book = cachedBook;
      } else {
        book = await _bookRepository.getBook(id);
      }
      bool loadedQuotes = book != null && book.quotes != null && book.quotes.length > 0;
      if(book == null) {
        emit(BookDetailsState.error());
      } else {
        emit(BookDetailsState.loadedBook(book, loadedQuotes: loadedQuotes));

        if(!loadedQuotes) {
          book = await _bookRepository.getQuotesForBook(book);
          emit(BookDetailsState.loadedBook(book, loadedQuotes: true)); // might not be needed
        }
      }
    } catch(_) {
      emit(BookDetailsState.error());
    }
  }
}