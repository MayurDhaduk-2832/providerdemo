import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Model/analyticsChartModel.dart';
import 'package:oneqlik/Model/money_spent_model.dart';
import 'package:oneqlik/Model/speed_chart_model.dart';
import 'package:oneqlik/Model/vehicle_expense_model.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import '../Model/vehicle_status_model.dart';
import 'package:oneqlik/Model/getfuel_price_model.dart';

class HomeProvider with ChangeNotifier {
  bool isLoading = false;
  List<VehicleStatus> vehicleStatusList = [];
  VehicleStatusModel vehicleStatusModel;

  //List<ChartData> chartData = [];
  List<ChartData> chartData = [];
  bool isVehicleLoading = false;

  getVehicleStatus(data, url) async {
    isVehicleLoading = true;
    chartData.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      vehicleStatusModel = VehicleStatusModel.fromJson(body);

      if (vehicleStatusModel.graph != null) {
        for (int i = 0; i < vehicleStatusModel.graph.length; i++) {
          isVehicleLoading = true;
          if (vehicleStatusModel.graph[i].value != 0.0) {
            chartData.add(
              ChartData(
                vehicleStatusModel.graph[i].name,
                vehicleStatusModel.graph[i].value,
                HexColor(vehicleStatusModel.graph[i].colour),
              ),
            );
          }
        }
      }

      isVehicleLoading = false;
      notifyListeners();
    } else {
      isVehicleLoading = false;
      print("vehicle status Api Error !!");
      notifyListeners();
    }
  }

  bool isFuelLoading = false;
  var chooseState;
  List<Datum> getFuelPriceList = [];

  getfuelPriceList(data, url) async {
    isFuelLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("FuelData-->${body}");

    if (response.statusCode == 200) {
      var response = GetFuelPrice.fromJson(body);
      getFuelPriceList = response.data;

      isFuelLoading = false;
      notifyListeners();
    } else {
      isFuelLoading = false;
      print("fuel price Api Error !!");
      notifyListeners();
    }
  }

  bool isVehicleExpenseLoading = false;
  List<ExpensesGraph> vehicleExpenseList = [];

  getVehicleExpense(data, url) async {
    isVehicleExpenseLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("Expense-->$body");
    if (response.statusCode == 200) {
      var response = VehicleExpensesModel.fromJson(body);
      vehicleExpenseList = response.graph;

      isVehicleExpenseLoading = false;
      notifyListeners();
    } else {
      isVehicleExpenseLoading = false;
      print("VehicleExpense Post Api Error !!");
      notifyListeners();
    }
  }

  bool isMoneyLoading = false;
  MoneySpentModel moneySpentModel;
  List<MoneySpentChart> spentChart = [];
  List<MoneySpentChart> spentMoneyChart = [];
  List<MoneySpentChart> spentDistanceChart = [];

  getMoneySpent(data, url) async {
    isMoneyLoading = true;
    spentChart.clear();
    spentMoneyChart.clear();
    spentDistanceChart.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("moneySpend-->$body");
    if (response.statusCode == 200) {
      moneySpentModel = MoneySpentModel.fromJson(body);

      print("moneySpentModel data length");
      print(moneySpentModel.data.length);
      for (int i = 0; i < moneySpentModel.data.length; i++) {
        isMoneyLoading = true;
        spentChart.add(
          MoneySpentChart(
            DateFormat("dd MMM").format(moneySpentModel.data[i].date),
            double.parse("${moneySpentModel.data[i].fuel}"),
          ),
        );

        spentMoneyChart.add(
          MoneySpentChart(
              DateFormat("dd MMM").format(moneySpentModel.data[i].date),
              0.0,
              double.parse("${moneySpentModel.data[i].money}"),
              0.0),
        );

        spentDistanceChart.add(
          MoneySpentChart(
            DateFormat("dd MMM").format(moneySpentModel.data[i].date),
            0.0,
            0.0,
            double.parse("${moneySpentModel.data[i].distanceKms}"),
          ),
        );
      }

      isMoneyLoading = false;
      notifyListeners();
    } else {
      isMoneyLoading = false;
      print("sevenDayGraph DashBoard Api Error !!");
      notifyListeners();
    }
  }

  AnalyticChartModel analyticChartModel;
  bool isAnalyticLoading = false;
  List<AnalyticsChart> analyticsDistance = [];

  getAnalyticsChart(data, url) async {
    isAnalyticLoading = true;
    analyticsDistance.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("moneySpend-->$body");
    if (response.statusCode == 200) {
      analyticChartModel = AnalyticChartModel.fromJson(body);

      print(analyticChartModel.data.length);
      for (int i = 0; i < analyticChartModel.data.length; i++) {
        analyticsDistance.add(
          AnalyticsChart(
            DateFormat("dd MMM").format(analyticChartModel.data[i].date),
            0.0,
            0.0,
            double.parse("${analyticChartModel.data[i].distanceKms}"),
          ),
        );
      }

      print("analyticsDistance");
      print(analyticsDistance);
      isAnalyticLoading = false;
      notifyListeners();
    } else {
      isAnalyticLoading = false;
      print("sevenDayGraph DashBoard Api Error !!");
      notifyListeners();
    }
  }

  bool isSpeedChartLoading = false;
  List<SpeedChartData> speedChart = [];

  speedChartAnalytics(data, url) async {
    speedChart.clear();
    isSpeedChartLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      for (int i = 0; i < body.length; i++) {
        speedChart.add(SpeedChartData(
          x: body[i]['key'],
          y: double.parse("${body[i]['value']}"),
        ));
      }

      isSpeedChartLoading = false;
      notifyListeners();
    } else {
      isSpeedChartLoading = false;
      print("Speed Chart Api Error !!");
      notifyListeners();
    }
  }
}
