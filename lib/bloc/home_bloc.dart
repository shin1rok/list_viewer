import 'package:bloc_provider/bloc_provider.dart';
import 'package:list_viewer/entity/article.dart';
import 'package:list_viewer/entity/articles.dart';
import 'package:list_viewer/repository/api_client.dart';
import 'package:list_viewer/repository/article_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc {
  final _articleRepository = ArticleRepository(client: ApiClient());

  final _articles = BehaviorSubject<List<Article>>();

  Stream<List<Article>> get articlesStream => _articles.stream;

  getArticles() async {
    var items = await _articleRepository.list();
    _articles.sink.add(items);
  }

  @override
  void dispose() {
    _articles.close();
  }
}
