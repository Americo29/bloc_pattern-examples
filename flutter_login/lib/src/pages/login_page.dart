import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/src/blocs/blocAuthentication/bloc_authentication.dart';
import 'package:flutter_login/src/blocs/blocLogin/bloc_login.dart';
import 'package:flutter_login/src/repositories/user_repository.dart';
import 'package:flutter_login/src/widget/loginForm_widget.dart';




class LoginPage extends StatelessWidget {

  final UserRepository userRepository;

  const LoginPage({Key key, @required this.userRepository}) 
            : assert(userRepository != null),
              super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context){
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}