import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/src/blocs/blocAuthentication/bloc_state.dart';
import 'package:flutter_login/src/blocs/delegate/bloc_delegate.dart';
import 'package:flutter_login/src/pages/home_page.dart';
import 'package:flutter_login/src/pages/login_page.dart';
import 'package:flutter_login/src/pages/splash_page.dart';
import 'package:flutter_login/src/widget/loading_widget.dart';

import 'src/blocs/blocAuthentication/bloc_authentication.dart';
import 'src/blocs/blocAuthentication/bloc_event.dart';
import 'src/repositories/user_repository.dart';
 


void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if(state is AuthenticationUninitialized){
            return SplashPage();
          }
          if(state is AuthenticationAuthenticated){
            return HomePage();
          }
          if(state is AuthenticationUnauthenticated){
            return LoginPage(userRepository: userRepository);
          }
          if(state is AuthenticationLoading){
            return LoadingIndicator();
          }
        },
      )
    );
  }
}