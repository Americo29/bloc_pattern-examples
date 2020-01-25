import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/src/blocs/timer_bloc.dart';
import 'package:flutter_timer/src/blocs/timer_state.dart';
import 'package:flutter_timer/src/widgets/actions_widget.dart';



class HomePage extends StatelessWidget {

  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timer')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0),
            child: Center(
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state){
                  final String minuteStr = ((state.duration / 60) % 60)
                    .floor()
                    .toString()
                    .padLeft(2, '0');
                  final String secondsStr = 
                    (state.duration % 60).floor().toString().padLeft(2, '0');
                  return Text(
                    '$minuteStr:$secondsStr',
                    style: timerTextStyle,
                  );
                },
              ),
            ),
          ),
          BlocBuilder<TimerBloc, TimerState>(
            condition: (previousState, state) => state.runtimeType != previousState.runtimeType,
            builder: (context, state) => ActionsWidget(),
          )
        ],
      )
    );
  }
}