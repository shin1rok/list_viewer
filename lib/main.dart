import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:list_viewer/bloc/home_bloc.dart';
import 'package:list_viewer/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocProvider(
        creator: (BuildContext context, BlocCreatorBag bag) {
          return HomeBloc();
        },
        child: const Home(),
      ),
    );
  }
}
