import 'package:flutter/material.dart';

Color getOlympicColors(int rank){
  Color result = Colors.grey.shade50;

  if(rank==1){
    result = const Color(0xffFEE101);
  }
  else if(rank==2){
    result = const Color(0xffA7A7AD);
  }
  else if(rank==3){
    result = const Color(0xffA77044);
  }

  return result;
}