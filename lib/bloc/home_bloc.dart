import 'package:bloc_provider/bloc_provider.dart';
import 'package:list_viewer/entity/article.dart';
import 'package:list_viewer/repository/api_client.dart';
import 'package:list_viewer/repository/article_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc {
  final _articleRepository = ArticleRepository(client: ApiClient());

  final _articles = BehaviorSubject<List<Article>>();

  Stream<List<Article>> get articlesStream => _articles.stream;

  void getArticles() async {
    var items = await _articleRepository.list();
    _articles.sink.add(items);
  }

  void search(String value) async {
    var items = await _articleRepository.search(value);
    _articles.sink.add(items);
  }

  final _search = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get searchStream => _search.stream;

  tapSearch() {
    _search.sink.add(true);
  }

  final _input = BehaviorSubject<String>.seeded('');

  Sink<String> get addressInputAction => _input.sink;

  @override
  void dispose() {
    _articles.close();
    _search.close();
  }
}
