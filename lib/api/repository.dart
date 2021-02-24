import 'dart:convert';

import 'package:cable_vasool/api/http/http_request.dart';
import 'package:cable_vasool/api/http/urls.dart';
import 'package:cable_vasool/api/models/add_connection_model.dart'
    as connection;
import 'package:cable_vasool/api/models/add_setup_box_model.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphQL/queries.dart';
import 'graphQL/connections.dart';
import 'models/dashboard_model.dart';
import 'models/login_model.dart';
import '../api/models/connection_list_model.dart';

class Repository {
  static GraphQLClient _client = GQLConnection.clientToQuery();

  Future<LoginModel> doLogin(String email, String password) async {
    return loginModelFromJson(await Request().post(
        url: Urls.login, body: {"identifier": email, "password": password}));
  }

  Future<AddSetupBoxModel> addSetupBox(
      {@required String setUpBoxSerial,
      @required int operatorID,
      @required int providerID}) async {
    final result = await _client.query(QueryOptions(
        documentNode: gql(Queries.addSetupBox(
            serialNumber: setUpBoxSerial,
            operatorId: operatorID,
            providerId: providerID))));

    if (result.hasException) {
      logger.e('error - ${result.exception}');
      return null;
    } else {
      logger.d('result = ${result.data}');
      return addSetupBoxModelFromJson(jsonEncode(result.data));
    }
  }

  Future<connection.AddConnectionModel> addConnection(
      {@required String customerName,
      @required String connectionNumber,
      @required String connectionAddedDate,
      @required int operatorId,
      @required int lineId,
      @required int dueAmount,
      @required int setUpBoxId}) async {
    final result = await _client.query(QueryOptions(
        documentNode: gql(Queries.addConnection(
            connectionAddedDate: connectionAddedDate,
            connectionNumber: connectionNumber,
            customerName: customerName,
            dueAmount: dueAmount,
            lineId: lineId,
            operatorId: operatorId,
            setUpBoxId: setUpBoxId))));

    if (result.hasException) {
      logger.e('error - ${result.exception}');
      return null;
    } else {
      logger.d('result = ${result.data}');
      return connection.addConnectionModelFromJson(jsonEncode(result.data));
    }
  }

  Future<DashboardModel> getDashboard({
    @required String paymentYear,
    @required String paymentMonth,
    @required String paymentDate,
  }) async {
    final result = await _client.query(
        QueryOptions(documentNode: gql(Queries.getDashboard()), variables: {
      "operator_id": int.parse(await Preferences.getOperatorId()),
      "payment_year": int.parse(paymentYear),
      "payment_month": int.parse(paymentMonth),
      "payment_date": paymentDate
    }));
    if (result.hasException) {
      logger.e('error - ${result.exception}');
      return null;
    } else {
      logger.d('result = ${result.data}');
      return dashboardModelFromJson(jsonEncode(result.data));
    }
  }

  Future<ConnectionListModel> getConnectionListByLine(
      {@required int lineId, @required int pageNumber}) async {
    final result = await _client.query(QueryOptions(
        documentNode: gql(Queries.getConnectionListByLine()),
        variables: {
          "lineId": lineId,
          "page": pageNumber,
          "payment_year": DateTime.now().year,
          "payment_month": DateTime.now().month,
        }));
    if (result.hasException) {
      logger.e('error - ${result.exception}');
      return null;
    } else {
      logger.d('result = ${result.data}');
      return connectionListModelFromJson(jsonEncode(result.data));
    }
  }
}
