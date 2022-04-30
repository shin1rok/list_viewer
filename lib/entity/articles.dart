import 'package:freezed_annotation/freezed_annotation.dart';
import 'article.dart';

part 'articles.freezed.dart';

@freezed
class Articles with _$Articles {
  factory Articles(List<Article> list) = _Articles;
}
