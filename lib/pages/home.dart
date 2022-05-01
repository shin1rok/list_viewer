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
    const title = 'List View';
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(bloc: bloc, title: title, focusNode: _focusNode),
        actions: [AppBarSearchAction(bloc: bloc)],
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
    );
  }
}

class AppBarSearchAction extends StatelessWidget {
  const AppBarSearchAction({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.searchStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data) {
          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              bloc.closeSearch();
              bloc.getArticles();
            },
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              bloc.openSearch();
            },
          );
        }
      },
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.bloc,
    required this.title,
    required FocusNode focusNode,
  })  : _focusNode = focusNode,
        super(key: key);

  final HomeBloc bloc;
  final String title;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.searchStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.data) {
          return Text(title);
        } else {
          return AppBarTextFormField(focusNode: _focusNode, bloc: bloc);
        }
      },
    );
  }
}

class AppBarTextFormField extends StatelessWidget {
  const AppBarTextFormField({
    Key? key,
    required FocusNode focusNode,
    required this.bloc,
  })  : _focusNode = focusNode,
        super(key: key);

  final FocusNode _focusNode;
  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: TextInputType.text,
        autofocus: true,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(hintText: 'Search'),
        onChanged: bloc.addressInputAction.add,
        onFieldSubmitted: (value) {
          bloc.search(value);
          _focusNode.unfocus();
        });
  }
}
