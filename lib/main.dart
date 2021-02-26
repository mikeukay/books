import 'package:books/repositories/book_repository.dart';
import 'package:books/router/custom_router.dart';
import 'package:books/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/book_list/book_list_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color hooloovoo = Color(0xFF42DAFA);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BookRepository(),
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snap) => snap.connectionState == ConnectionState.done ? BlocProvider(
          create: (context) => BookListCubit(
              bookRepository: RepositoryProvider.of<BookRepository>(context)
          )..initialize(),
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: hooloovoo,
              accentColor: hooloovoo,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onGenerateRoute: CustomRouter.generateRoute,
            initialRoute: HOME_ROUTE,
          ),
        ) : Container(
          color: Colors.white,
        ),
      ),
    );
  }
}