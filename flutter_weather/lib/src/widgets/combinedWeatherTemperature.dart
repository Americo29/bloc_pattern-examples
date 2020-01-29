import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/blocs/blocs.dart';
import 'package:flutter_weather/src/models/models.dart' as model;
import 'package:flutter_weather/src/widgets/temperature.dart';
import 'package:flutter_weather/src/widgets/weatherConditions.dart';

class CombinedWeatherTemperature extends StatelessWidget {
  final model.Weather weather;

  const CombinedWeatherTemperature({Key key, @required this.weather})
      : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
                child: WeatherConditions(condition: weather.condition)),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return Temperature(
                      temperature: weather.temp,
                      high: weather.maxTemp,
                      low: weather.minTemp,
                      units: state.temperatureUnits,
                    );
                  },
                )),
          ],
        ),
        Center(
          child: Text(
            weather.formattedCondition,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
