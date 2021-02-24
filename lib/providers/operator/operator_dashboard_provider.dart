import 'package:cable_vasool/api/models/dashboard_model.dart';
import 'package:cable_vasool/api/repository.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OperatorDashboardProvider with ChangeNotifier {
  DashboardState _state = DashboardState.loading;

  DashboardModel _model;

  List<LineModel> _lineList = [];

  List<LineModel> get lineList => _lineList;

  set lineList(List<LineModel> value) {
    _lineList = value;
  }

  DashboardModel get model => _model;

  set model(DashboardModel value) {
    _model = value;
  }

  DashboardState get state => _state;

  set state(DashboardState value) {
    _state = value;
  }

  getDashboard({DateTime today}) async {
    if (today == null) today = DateTime.now();
    DashboardModel apiModel = await Repository().getDashboard(
        paymentYear: today.year.toString(),
        paymentMonth: today.month.toString(),
        paymentDate: DateFormat('yyyy-MM-dd').format(today));
    if (apiModel == null) {
      state = DashboardState.error;
      notifyListeners();
    } else {
      model = apiModel;

      model.lines.forEach((line) {
        // var selectedLine = model.connectionsConnection.groupBy.line
        //     .singleWhere((element) => element.key == line.id);
        //
        // print('selectedLine = ${selectedLine.key}');
        var totalConnections = '0';
        var totalDueAmount = '0';
        var totalAmountCollected = '0';
        var totalConnectionsCollected = '0';

        try {
          totalConnections = model.connectionsConnection.groupBy.line
              .where((element) => element.key == line.id)
              .toList()
              .first
              .connection
              .aggregate
              .count
              .toString();
        } catch (e){
          totalConnections = '0';
        }

        try{
          totalDueAmount = model.connectionsConnection.groupBy.line
              .where((element) => element.key == line.id)
              .toList()
              .first
              .connection
              .aggregate
              .sum
              .dueAmount
              .toString();
        } catch (e){
          totalDueAmount = '0';
        }

        try {
          totalAmountCollected = model.paymentHistoriesConnection.groupBy.line
              .firstWhere((element) => element.key == line.id)
              .connection
              .aggregate
              .sum
              .amountCollected
              .toString();
        } catch (e){
          totalAmountCollected = '0';
        }

        try{
          totalConnectionsCollected = model
              .paymentHistoriesConnection.groupBy.line
              .firstWhere((element) => element.key == line.id)
              .connection
              .aggregate
              .count
              .toString();
        } catch (e){
          totalConnectionsCollected = '0';
        }

        LineModel lineModel = LineModel(
          id: line.id,
          name: line.lineName,
          totalConnections: totalConnections,
          totalDueAmount: totalDueAmount,
          totalAmountCollected: totalAmountCollected,
          totalConnectionsCollected: totalConnectionsCollected,
          isSelected: false
        );

        lineList.add(lineModel);
      });

      state = DashboardState.loaded;
      notifyListeners();
    }
  }
}

class LineModel {
  String id;
  String name;
  String totalConnections;
  String totalDueAmount;
  String totalConnectionsCollected;
  String totalAmountCollected;
  bool isSelected;

  LineModel(
      {this.id,
      this.name,
      this.totalConnections,
      this.totalDueAmount,
      this.totalConnectionsCollected,
      this.totalAmountCollected,
      this.isSelected});
}
