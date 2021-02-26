import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<dynamic>> getQuotes(String bookId) async {
    DocumentReference quotesDocRef = db.collection("quotes").doc(bookId);
    DocumentSnapshot quotesDoc = await quotesDocRef.get();
    if(!quotesDoc.data().containsKey('quotes') || quotesDoc.data()['quotes'].length == 0)
      return [];
    return quotesDoc.data()['quotes'];
  }
}