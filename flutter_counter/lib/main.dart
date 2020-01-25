import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/src/bloc/counter_bloc.dart';
import 'package:flutter_counter/src/pages/home_page.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: BlocProvider<CounterBloc>(
        create: (context) => CounterBloc(),
        child: HomePage(),
      ),
    );
  }
}