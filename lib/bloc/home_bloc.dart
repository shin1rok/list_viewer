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

  openSearch() {
    _search.sink.add(true);
  }

  closeSearch() {
    _search.sink.add(false);
  }

  final _input = BehaviorSubject<String>.seeded('');

  Sink<String> get addressInputAction => _input.sink;

  final _favArticles = BehaviorSubject<List<Article>>();

  Stream<List<Article>> get favArticlesStream => _favArticles.stream;

  void toggleFavorite(Article article) {
    // お気に入りがある場合は削除、ない場合は追加
    // それによりお気に入りのStreamが更新されて画面のハートが切り替わる
    getFavArticles();
  }

  void getFavArticles() async {
    // 一旦仮でList全部取得する
    var items = await _articleRepository.list();
    _favArticles.sink.add(items);
  }

  @override
  void dispose() {
    _articles.close();
    _search.close();
  }
}
