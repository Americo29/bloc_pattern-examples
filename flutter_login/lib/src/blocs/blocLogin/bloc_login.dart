import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/src/blocs/blocAuthentication/bloc_event.dart';
import 'package:meta/meta.dart';

import 'package:flutter_login/src/blocs/blocAuthentication/bloc_authentication.dart';
import 'package:flutter_login/src/blocs/blocLogin/blocLogin_event.dart';
import 'package:flutter_login/src/blocs/blocLogin/blocLogin_state.dart';
import 'package:flutter_login/src/repositories/user_repository.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
    @required this.userRepository,
  })  :assert(userRepository != null),
       assert(authenticationBloc != null);


  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginButtonPressed){
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      }catch (error){
        yield LoginFailure(error: error.toString());
      }
    }
  } 
}