// Dart imports
import 'dart:convert';

// Package imports
import 'package:http/http.dart' as http;

// Models
import '../models/news_newstile.dart';

// Scripts
import './fas.dart';

class News {
  // ignore: constant_identifier_names
  static const String BASE_URL = "https://api.first.org";

  static Future<List<NewsTile>?> getNews() async {
    final response = await http.get(Uri.parse("$BASE_URL/data/v1/news"));

    if (response.statusCode != 200) return null;

    final responseJson = jsonDecode(response.body);
    List<NewsTile> data = [];
    for (Map<String, dynamic> newsData in responseJson["data"] as List) {
      bool favourite =
          await SecureStore.read("favourites/${newsData["id"]}") != null;

      data.add(NewsTile(
          id: newsData["id"] as int,
          title: newsData["title"] ?? "",
          summary: newsData["summary"] ?? "",
          published: newsData["published"] ?? "",
          favourite: favourite));
    }

    return data;
  }
}
