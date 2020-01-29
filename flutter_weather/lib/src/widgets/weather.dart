import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/blocs/blocs.dart';
import 'package:flutter_weather/src/blocs/themebloc/theme_bloc.dart';
import 'package:flutter_weather/src/widgets/citySelection_page.dart';
import 'package:flutter_weather/src/widgets/combinedWeatherTemperature.dart';
import 'package:flutter_weather/src/widgets/gradientContainer.dart';
import 'package:flutter_weather/src/widgets/lastUpdate.dart';
import 'package:flutter_weather/src/widgets/location.dart';
import 'package:flutter_weather/src/widgets/settings.dart';

class Weather extends StatefulWidget {
  const Weather({Key key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                BlocProvider.of<WeatherBloc>(context)
                    .add(FetchWeather(city: city));
              }
            },
          )
        ],
      ),
      body: Center(
          child: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoaded) {
            BlocProvider.of<ThemeBloc>(context).add(
              WeatherChanged(condition: state.weather.condition),
            );
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherEmpty) {
              return Center(
                child: Text('Por favor seleccione una ciudad'),
              );
            }
            if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is WeatherLoaded) {
              final weather = state.weather;

              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return GradientContainer(
                    color: themeState.color,
                    child: RefreshIndicator(
                      onRefresh: () {
                        BlocProvider.of<WeatherBloc>(context).add(
                          RefreshWeather(city: state.weather.location),
                        );
                        return _refreshCompleter.future;
                      },
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Center(
                                child: Location(
                              location: weather.location,
                            )),
                          ),
                          Center(
                            child: LastUpdate(dateTime: weather.lastUpdated),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: Center(
                              child: CombinedWeatherTemperature(
                                weather: weather,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is WeatherError) {
              return Text(
                'Ha ocurrido algún error',
                style: TextStyle(color: Colors.red),
              );
            }
          },
        ),
      )),
    );
  }
}
