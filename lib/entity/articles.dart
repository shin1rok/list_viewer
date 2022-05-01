import 'package:freezed_annotation/freezed_annotation.dart';
import 'article.dart';

part 'articles.freezed.dart';

@freezed
class Articles with _$Articles {
  // 型があるのでこれを上手く使ってみたい
  factory Articles(List<Article> list) = _Articles;
}
