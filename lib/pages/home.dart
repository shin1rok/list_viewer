import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:list_viewer/bloc/home_bloc.dart';
import 'package:list_viewer/entity/article.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeBloc>(context);
    bloc.getArticles();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Long List';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: StreamBuilder(
          stream: bloc.articlesStream,
          initialData: const <Article>[],
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Article article = snapshot.data[index];
                  return ListTile(title: Text(article.title), subtitle: Text(article.id.toString()));
                });
          },
        ),
      ),
    );
  }
}
