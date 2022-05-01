import 'dart:convert';
import 'package:list_viewer/entity/article.dart';
import 'api_client.dart';

abstract class ArticleRepositoryInterface {
  Future<List<Article>> list();

  Future<List<Article>> search(String topic);
}

class ArticleRepository implements ArticleRepositoryInterface {
  final Client _client;

  ArticleRepository({
    required Client client,
  }) : _client = client;

  @override
  Future<List<Article>> list() async {
    try {
      final response = await _client.getArticles();
      final jsonResponse = json.decode(response.body);
      final list = jsonResponse['articles'].map<Article>((data) => Article.fromJson(data)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Article>> search(String topic) async {
    try {
      final response = await _client.topicSearch(topic);
      final jsonResponse = json.decode(response.body);
      final list = jsonResponse['articles'].map<Article>((data) => Article.fromJson(data)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }
}
