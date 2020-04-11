import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DateFormatter.dart';

class BaseClock extends StatefulWidget{

  BaseClock({Key key}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    var state = new BaseClockState();
    state.startClock();
    return state;
  }

}

class BaseClockState<T extends StatefulWidget> extends State{

  BaseClockState() : super();

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text.rich(
        TextSpan(
            text: "${now.year}-${now.month}-${now.day} ${DateFormatter.pad0(now.hour)}:${DateFormatter.pad0(now.minute)}:${DateFormatter.pad0(now.second)}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: Colors.red,
              height: 1.5,
            )
        )
    );
  }

  startClock(){
    Duration duration = Duration(microseconds: 1000);
    Timer.periodic(duration, (Timer t) {
      if(!mounted){
        return;
      }
      setState(() {
        now = DateTime.now();
      });
    });
  }



}