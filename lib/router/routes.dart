const String HOME_ROUTE = "/";
const String BOOK_ROUTE = "/book";

const String BOOK_ID_PARAM = "id";

class RouterUtils {
  static String getRoute({String route, Map<String, String> params}) {
    return Uri(path: route, queryParameters: params).toString();
  }
}