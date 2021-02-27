import 'package:books/cubits/book_details/book_details_cubit.dart';
import 'package:books/cubits/book_list/book_list_cubit.dart';
import 'package:books/custom_scaffold.dart';
import 'package:books/models/book.dart';
import 'package:books/repositories/book_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookScreen extends StatelessWidget {
  final String bookId;

  const BookScreen({Key key, this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocProvider<BookDetailsCubit>(
        create: (context) {
          BookDetailsCubit cubit = BookDetailsCubit(
            bookRepository: RepositoryProvider.of<BookRepository>(context),
          );
          List<Book> loadedBooks = BlocProvider.of<BookListCubit>(context).state.books;
          bool bookFoundInList = false;

          if(loadedBooks != null && loadedBooks.length > 0) {
            for(int i = 0;i < loadedBooks.length && !bookFoundInList; ++i) {
              if(loadedBooks.elementAt(i).id == bookId) {
                cubit.loadBook(cachedBook: loadedBooks.elementAt(i));
                bookFoundInList = true;
              }
            }
          }

          if(!bookFoundInList) {
            cubit.loadBook(id: bookId);
          }
          return cubit;
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<BookDetailsCubit, BookDetailsState>(
              builder: (context, state) {
                if(state.status == BookDetailsStatus.load_error)
                  return Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(
                      "Could not load this book :(",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                if(state.status == BookDetailsStatus.loading)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                return _BookRepresentation(book: state.book);
              },
            );
          },
        ),
      ),
    );
  }
}

class _BookRepresentation extends StatelessWidget {
  final Book book;

  const _BookRepresentation({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imgHeight = 500.0;
    if(MediaQuery.of(context).size.width < 1000) {
      imgHeight = 300;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: imgHeight, minHeight: imgHeight),
              child: CachedNetworkImage(
                imageUrl: book.photoUrl,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) => const SizedBox.shrink(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          book.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 16.0),
        Text(
          "Author: ${book.author}",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 8.0),
        Text(
          "Rating: ${book.rating} / 10",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 8.0),
        Text(
          "Finished reading: ${book.dateRead.day}/${book.dateRead.month}/${book.dateRead.year}",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 32.0),
        Text(
          "Review",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 8.0),
        Text(book.review),
        const SizedBox(height: 32.0),
        Text(
          "Quotes",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 8.0),
        _QuoteList(),
      ],
    );
  }
}

class _QuoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsCubit, BookDetailsState>(
      buildWhen: (oldState, newState) => oldState.loadedQuotes != newState.loadedQuotes || oldState.book?.quotes != newState.book?.quotes,
      builder: (context, state) {
        if(state.loadedQuotes == false)
          return const Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.book.quotes.length,
          itemBuilder: (context, index) {
            String t = state.book.quotes[index].text;
            t = t.replaceAll("\"", "'");
            t = t.replaceAll("  ", " ").replaceAll("''", "'"); // weird formatting from ReadEra
            t = "\"" + t + "\"";
            return Text(t + "\n");
          },
        );
      },
    );
  }
}
