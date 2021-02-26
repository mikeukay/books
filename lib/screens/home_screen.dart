import 'package:books/cubits/book_list/book_list_cubit.dart';
import 'package:books/custom_scaffold.dart';
import 'package:books/main.dart';
import 'package:books/models/book.dart';
import 'package:books/router/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          const SizedBox(height: 32.0),
          _Description(),
          Divider(height: 32.0),
          _BookList(),
        ],
      ),
      onScrollEndNotificationHandler: (ScrollNotification scrollNotif) {
        if(scrollNotif.metrics.extentAfter <= 500.0) {
          BookListState state = BlocProvider.of<BookListCubit>(context).state;
          if(state.status == BookListStatus.loaded && state.loadingMore == false && state.canLoadMore == true) {
            BlocProvider.of<BookListCubit>(context).loadMoreBooks();
          }
        }
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Books I've Read",
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

class _Description extends StatelessWidget {
  TextSpan _clickableLink({String text, String url}) {
    return TextSpan(
        text: text,
        style: TextStyle(color: MyApp.hooloovoo),
        recognizer: TapGestureRecognizer()..onTap = () => launch(url)
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headline5,
        children: [
          const TextSpan(text: "I love reading books, especially good ones. Inspired by "),
          _clickableLink(text: "sive.rs/books", url: "https://sive.rs/book"),
          const TextSpan(text: ", this list contains some of the books that I've read. "),
          const TextSpan(text: "Most of them also have a 'quotes' section where I put the passages which I found interesting.\n\n"),
          const TextSpan(text: "My rating system is special: "),
          const TextSpan(
            text: "a 'good' book gets a rating of 5.0, while an 'excellent' book gets around 8.5",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ". If you see a 9.5, read that book immediately! Similarly, if you see a 10, I've been kidnapped and you should send help ASAP.\n\n"),
          const TextSpan(text: "MANDATORY AD: ", style: TextStyle(fontStyle: FontStyle.italic)),
          const TextSpan(text: "Want to learn how to code this app? Visit "),
          _clickableLink(text: "fireacademy.io", url: "https://platform.fireacademy.io"),
          const TextSpan(text: " and follow my free course - or just view the source on "),
          _clickableLink(text: "GitHub", url: "https://github.com/mikeukay/books"),
          const TextSpan(text: "."),
        ],
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListCubit, BookListState>(
      builder: (context, state) {
        if(state.status == BookListStatus.load_error)
          return Center(
            child: Text(
              "Error while loading books :(",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        if(state.status == BookListStatus.loading || state.status == BookListStatus.not_initialized)
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        if(state.status == BookListStatus.loaded && state.books.length == 0)
          return Center(
            child: Text(
              "No books found :(",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.books.length + (state.canLoadMore ? 1 : 0),
          itemBuilder: (context, index) {
            if(index == state.books.length)
              return Padding(
                padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            final Book book = state.books[index];
            return _BookCard(book: book);
          },
        );
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CachedNetworkImage(
                      imageUrl: book.photoUrl,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      placeholder: (context, url) => const SizedBox.shrink(),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "by ${book.author}",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "${book.rating} / 10",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                "${book.review}\n\nFinished reading: ${book.dateRead.day}/${book.dateRead.month}/${book.dateRead.year}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(RouterUtils.getRoute(
            route: BOOK_ROUTE,
            params: {BOOK_ID_PARAM: book.id}));
      },
    );
  }
}

