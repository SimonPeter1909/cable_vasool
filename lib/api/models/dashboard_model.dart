// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.totalConnections,
    this.paymentCollected,
    this.connectionsCollected,
    this.todayPaymentCollected,
    this.todayConnectionsCollected,
    this.totalSetupBox,
    this.activeSetupBox,
    this.lines,
    this.connectionsConnection,
    this.paymentHistoriesConnection,
  });

  TotalConnections totalConnections;
  PaymentCollected paymentCollected;
  ActiveSetupBox connectionsCollected;
  PaymentCollected todayPaymentCollected;
  ActiveSetupBox todayConnectionsCollected;
  ActiveSetupBox totalSetupBox;
  ActiveSetupBox activeSetupBox;
  List<DashboardModelLine> lines;
  ConnectionsConnection connectionsConnection;
  PaymentHistoriesConnection paymentHistoriesConnection;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    totalConnections: json["totalConnections"] == null ? null : TotalConnections.fromJson(json["totalConnections"]),
    paymentCollected: json["paymentCollected"] == null ? null : PaymentCollected.fromJson(json["paymentCollected"]),
    connectionsCollected: json["connectionsCollected"] == null ? null : ActiveSetupBox.fromJson(json["connectionsCollected"]),
    todayPaymentCollected: json["todayPaymentCollected"] == null ? null : PaymentCollected.fromJson(json["todayPaymentCollected"]),
    todayConnectionsCollected: json["todayConnectionsCollected"] == null ? null : ActiveSetupBox.fromJson(json["todayConnectionsCollected"]),
    totalSetupBox: json["totalSetupBox"] == null ? null : ActiveSetupBox.fromJson(json["totalSetupBox"]),
    activeSetupBox: json["activeSetupBox"] == null ? null : ActiveSetupBox.fromJson(json["activeSetupBox"]),
    lines: json["lines"] == null ? null : List<DashboardModelLine>.from(json["lines"].map((x) => DashboardModelLine.fromJson(x))),
    connectionsConnection: json["connectionsConnection"] == null ? null : ConnectionsConnection.fromJson(json["connectionsConnection"]),
    paymentHistoriesConnection: json["paymentHistoriesConnection"] == null ? null : PaymentHistoriesConnection.fromJson(json["paymentHistoriesConnection"]),
  );

  Map<String, dynamic> toJson() => {
    "totalConnections": totalConnections == null ? null : totalConnections.toJson(),
    "paymentCollected": paymentCollected == null ? null : paymentCollected.toJson(),
    "connectionsCollected": connectionsCollected == null ? null : connectionsCollected.toJson(),
    "todayPaymentCollected": todayPaymentCollected == null ? null : todayPaymentCollected.toJson(),
    "todayConnectionsCollected": todayConnectionsCollected == null ? null : todayConnectionsCollected.toJson(),
    "totalSetupBox": totalSetupBox == null ? null : totalSetupBox.toJson(),
    "activeSetupBox": activeSetupBox == null ? null : activeSetupBox.toJson(),
    "lines": lines == null ? null : List<dynamic>.from(lines.map((x) => x.toJson())),
    "connectionsConnection": connectionsConnection == null ? null : connectionsConnection.toJson(),
    "paymentHistoriesConnection": paymentHistoriesConnection == null ? null : paymentHistoriesConnection.toJson(),
  };
}

class ActiveSetupBox {
  ActiveSetupBox({
    this.aggregate,
  });

  ActiveSetupBoxAggregate aggregate;

  factory ActiveSetupBox.fromJson(Map<String, dynamic> json) => ActiveSetupBox(
    aggregate: json["aggregate"] == null ? null : ActiveSetupBoxAggregate.fromJson(json["aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "aggregate": aggregate == null ? null : aggregate.toJson(),
  };
}

class ActiveSetupBoxAggregate {
  ActiveSetupBoxAggregate({
    this.count,
  });

  int count;

  factory ActiveSetupBoxAggregate.fromJson(Map<String, dynamic> json) => ActiveSetupBoxAggregate(
    count: json["count"] == null ? null : json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
  };
}

class ConnectionsConnection {
  ConnectionsConnection({
    this.groupBy,
  });

  ConnectionsConnectionGroupBy groupBy;

  factory ConnectionsConnection.fromJson(Map<String, dynamic> json) => ConnectionsConnection(
    groupBy: json["groupBy"] == null ? null : ConnectionsConnectionGroupBy.fromJson(json["groupBy"]),
  );

  Map<String, dynamic> toJson() => {
    "groupBy": groupBy == null ? null : groupBy.toJson(),
  };
}

class ConnectionsConnectionGroupBy {
  ConnectionsConnectionGroupBy({
    this.line,
  });

  List<PurpleLine> line;

  factory ConnectionsConnectionGroupBy.fromJson(Map<String, dynamic> json) => ConnectionsConnectionGroupBy(
    line: json["line"] == null ? null : List<PurpleLine>.from(json["line"].map((x) => PurpleLine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "line": line == null ? null : List<dynamic>.from(line.map((x) => x.toJson())),
  };
}

class PurpleLine {
  PurpleLine({
    this.key,
    this.connection,
  });

  String key;
  TotalConnections connection;

  factory PurpleLine.fromJson(Map<String, dynamic> json) => PurpleLine(
    key: json["key"] == null ? null : json["key"],
    connection: json["connection"] == null ? null : TotalConnections.fromJson(json["connection"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "connection": connection == null ? null : connection.toJson(),
  };
}

class TotalConnections {
  TotalConnections({
    this.aggregate,
  });

  TotalConnectionsAggregate aggregate;

  factory TotalConnections.fromJson(Map<String, dynamic> json) => TotalConnections(
    aggregate: json["aggregate"] == null ? null : TotalConnectionsAggregate.fromJson(json["aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "aggregate": aggregate == null ? null : aggregate.toJson(),
  };
}

class TotalConnectionsAggregate {
  TotalConnectionsAggregate({
    this.sum,
    this.count,
  });

  PurpleSum sum;
  int count;

  factory TotalConnectionsAggregate.fromJson(Map<String, dynamic> json) => TotalConnectionsAggregate(
    sum: json["sum"] == null ? null : PurpleSum.fromJson(json["sum"]),
    count: json["count"] == null ? null : json["count"],
  );

  Map<String, dynamic> toJson() => {
    "sum": sum == null ? null : sum.toJson(),
    "count": count == null ? null : count,
  };
}

class PurpleSum {
  PurpleSum({
    this.dueAmount,
  });

  int dueAmount;

  factory PurpleSum.fromJson(Map<String, dynamic> json) => PurpleSum(
    dueAmount: json["due_amount"] == null ? null : json["due_amount"],
  );

  Map<String, dynamic> toJson() => {
    "due_amount": dueAmount == null ? null : dueAmount,
  };
}

class DashboardModelLine {
  DashboardModelLine({
    this.id,
    this.lineName,
  });

  String id;
  String lineName;

  factory DashboardModelLine.fromJson(Map<String, dynamic> json) => DashboardModelLine(
    id: json["id"] == null ? null : json["id"],
    lineName: json["line_name"] == null ? null : json["line_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "line_name": lineName == null ? null : lineName,
  };
}

class PaymentCollected {
  PaymentCollected({
    this.aggregate,
  });

  PaymentCollectedAggregate aggregate;

  factory PaymentCollected.fromJson(Map<String, dynamic> json) => PaymentCollected(
    aggregate: json["aggregate"] == null ? null : PaymentCollectedAggregate.fromJson(json["aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "aggregate": aggregate == null ? null : aggregate.toJson(),
  };
}

class PaymentCollectedAggregate {
  PaymentCollectedAggregate({
    this.sum,
  });

  FluffySum sum;

  factory PaymentCollectedAggregate.fromJson(Map<String, dynamic> json) => PaymentCollectedAggregate(
    sum: json["sum"] == null ? null : FluffySum.fromJson(json["sum"]),
  );

  Map<String, dynamic> toJson() => {
    "sum": sum == null ? null : sum.toJson(),
  };
}

class FluffySum {
  FluffySum({
    this.amountCollected,
  });

  int amountCollected;

  factory FluffySum.fromJson(Map<String, dynamic> json) => FluffySum(
    amountCollected: json["amount_collected"] == null ?  0 : json["amount_collected"],
  );

  Map<String, dynamic> toJson() => {
    "amount_collected": amountCollected == null ? null : amountCollected,
  };
}

class PaymentHistoriesConnection {
  PaymentHistoriesConnection({
    this.groupBy,
  });

  PaymentHistoriesConnectionGroupBy groupBy;

  factory PaymentHistoriesConnection.fromJson(Map<String, dynamic> json) => PaymentHistoriesConnection(
    groupBy: json["groupBy"] == null ? null : PaymentHistoriesConnectionGroupBy.fromJson(json["groupBy"]),
  );

  Map<String, dynamic> toJson() => {
    "groupBy": groupBy == null ? null : groupBy.toJson(),
  };
}

class PaymentHistoriesConnectionGroupBy {
  PaymentHistoriesConnectionGroupBy({
    this.line,
  });

  List<FluffyLine> line;

  factory PaymentHistoriesConnectionGroupBy.fromJson(Map<String, dynamic> json) => PaymentHistoriesConnectionGroupBy(
    line: json["line"] == null ? null : List<FluffyLine>.from(json["line"].map((x) => FluffyLine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "line": line == null ? null : List<dynamic>.from(line.map((x) => x.toJson())),
  };
}

class FluffyLine {
  FluffyLine({
    this.key,
    this.connection,
  });

  String key;
  Connection connection;

  factory FluffyLine.fromJson(Map<String, dynamic> json) => FluffyLine(
    key: json["key"] == null ? null : json["key"],
    connection: json["connection"] == null ? null : Connection.fromJson(json["connection"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "connection": connection == null ? null : connection.toJson(),
  };
}

class Connection {
  Connection({
    this.aggregate,
  });

  PurpleAggregate aggregate;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    aggregate: json["aggregate"] == null ? null : PurpleAggregate.fromJson(json["aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "aggregate": aggregate == null ? null : aggregate.toJson(),
  };
}

class PurpleAggregate {
  PurpleAggregate({
    this.count,
    this.sum,
  });

  int count;
  FluffySum sum;

  factory PurpleAggregate.fromJson(Map<String, dynamic> json) => PurpleAggregate(
    count: json["count"] == null ? null : json["count"],
    sum: json["sum"] == null ? null : FluffySum.fromJson(json["sum"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
    "sum": sum == null ? null : sum.toJson(),
  };
}
