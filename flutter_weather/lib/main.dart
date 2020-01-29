import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/blocs/blocs.dart';
import 'package:flutter_weather/src/blocs/settingsbloc/settings_bloc.dart';
import 'package:flutter_weather/src/blocs/themebloc/theme_bloc.dart';
import 'package:flutter_weather/src/widgets/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather/src/blocs/simple_bloc_delegate.dart';
import 'package:flutter_weather/src/repositories/repositories.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(
    httpClient: http.Client(),
  ));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),          
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: MyApp(weatherRepository: weatherRepository),
    )
  );
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  MyApp({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            home: BlocProvider(
              create: (context) =>
                  WeatherBloc(weatherRepository: weatherRepository),
              child: Weather(),
            ));
      },
    );
  }
}
