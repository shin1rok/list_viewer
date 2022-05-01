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
  final FocusNode _focusNode = FocusNode(); // BLoCに書きたい

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
          title: StreamBuilder(
            stream: bloc.searchStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.data) {
                return const Text(title);
              } else {
                return TextFormField(
                    keyboardType: TextInputType.text,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    onChanged: bloc.addressInputAction.add,
                    onFieldSubmitted: (value) {
                      print(value);
                      bloc.search(value);
                      _focusNode.unfocus();
                    });
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Show Snackbar',
              onPressed: () {
                bloc.tapSearch();
              },
            )
          ],
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
