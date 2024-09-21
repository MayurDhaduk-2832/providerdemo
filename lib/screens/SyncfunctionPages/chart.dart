import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final num y;
  final Color color;
}


class ChartSampleData {
  ChartSampleData({this.x,this.y,});
  final dynamic x;
  final num y;
}

class FuelChart {
  FuelChart({this.x,this.y,this.x2});
  final dynamic x;
  final num x2;
  final num y;
}


class GpsSpeedVariationChart {
  GpsSpeedVariationChart({this.x,this.y});
  final dynamic x;
  final num y;
}

class MoneySpentChart {
  MoneySpentChart(this.x, [this.fuel, this.money, this.distance,this.color]);
  final dynamic x;
  final num fuel;
  final num money;
  final num distance;
  final Color color;
}

class AnalyticsChart {
  AnalyticsChart(this.x, [this.fuel, this.money, this.distance,this.color]);
  final dynamic x;
  final num fuel;
  final num money;
  final num distance;
  final Color color;
}


class SpeedChartData {
  SpeedChartData({this.x,this.y});
  final String x;
  final num y;
}



