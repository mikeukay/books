import 'package:cloud_firestore/cloud_firestore.dart';

class BookDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, DocumentSnapshot> _bookSnapshots = {};

  Future<List<Map<String, dynamic>>> getRecentBooksByRating({int limit = 10, String after}) async {
    Query booksRef = db.collection("books").orderBy('rating', descending: true).orderBy('date_read', descending: true);
    if(after != null && _bookSnapshots.containsKey(after)) {
      booksRef = booksRef.startAfterDocument(_bookSnapshots[after]);
    }
    if(limit > 0) booksRef = booksRef.limit(limit);

    final QuerySnapshot booksSnap = await booksRef.get();
    List<Map<String, dynamic>> books = [];
    booksSnap.docs.forEach((bookDoc) {
      books.add(bookDoc.data()..addAll({
        "id": bookDoc.id,
      }));
      if(!_bookSnapshots.containsKey(bookDoc.id)) {
        _bookSnapshots.addAll({bookDoc.id: bookDoc});
      }
    });
    return books;
  }

  Future<Map<String, dynamic>> getBook(String id) async {
    DocumentReference bookDocRef = db.collection("books").doc(id);
    DocumentSnapshot bookDoc = await bookDocRef.get();
    return bookDoc.data()..addAll({
      "id": bookDoc.id,
    });
  }
}