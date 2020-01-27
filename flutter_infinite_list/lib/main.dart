import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/src/bloc/bloc.dart';
import 'package:flutter_infinite_list/src/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/src/bloc/post_bloc.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        body: BlocProvider(
          create: (context) => PostBloc(httpClient: http.Client())..add(Fetch()),
            child: HomePage(),
        )
      ),
    );
  }
}