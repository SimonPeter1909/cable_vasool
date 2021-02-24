// To parse this JSON data, do
//
//     final connectionListModel = connectionListModelFromJson(jsonString);

import 'dart:convert';

ConnectionListModel connectionListModelFromJson(String str) => ConnectionListModel.fromJson(json.decode(str));

String connectionListModelToJson(ConnectionListModel data) => json.encode(data.toJson());

class ConnectionListModel {
  ConnectionListModel({
    this.connections,
  });

  List<Connection> connections;

  factory ConnectionListModel.fromJson(Map<String, dynamic> json) => ConnectionListModel(
    connections: json["connections"] == null ? null : List<Connection>.from(json["connections"].map((x) => Connection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "connections": connections == null ? null : List<dynamic>.from(connections.map((x) => x.toJson())),
  };
}

class Connection {
  Connection({
    this.id,
    this.customerName,
    this.connectionNumber,
    this.connectionAddedDate,
    this.dueAmount,
    this.setupBox,
    this.disconnectedHistories,
    this.paymentHistories,
    this.line,
    this.isClicked
  });

  String id;
  String customerName;
  String connectionNumber;
  DateTime connectionAddedDate;
  int dueAmount;
  SetupBox setupBox;
  List<DisconnectedHistory> disconnectedHistories;
  List<dynamic> paymentHistories;
  Line line;
  bool isClicked;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    id: json["id"] == null ? null : json["id"],
    customerName: json["customer_name"] == null ? null : json["customer_name"],
    connectionNumber: json["connection_number"] == null ? null : json["connection_number"],
    connectionAddedDate: json["connection_added_date"] == null ? null : DateTime.parse(json["connection_added_date"]),
    dueAmount: json["due_amount"] == null ? null : json["due_amount"],
    setupBox: json["setup_box"] == null ? null : SetupBox.fromJson(json["setup_box"]),
    disconnectedHistories: json["disconnected_histories"] == null ? null : List<DisconnectedHistory>.from(json["disconnected_histories"].map((x) => DisconnectedHistory.fromJson(x))),
    paymentHistories: json["payment_histories"] == null ? null : List<dynamic>.from(json["payment_histories"].map((x) => x)),
    line: json["line"] == null ? null : Line.fromJson(json["line"]),
    isClicked: false
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customer_name": customerName == null ? null : customerName,
    "connection_number": connectionNumber == null ? null : connectionNumber,
    "connection_added_date": connectionAddedDate == null ? null : "${connectionAddedDate.year.toString().padLeft(4, '0')}-${connectionAddedDate.month.toString().padLeft(2, '0')}-${connectionAddedDate.day.toString().padLeft(2, '0')}",
    "due_amount": dueAmount == null ? null : dueAmount,
    "setup_box": setupBox == null ? null : setupBox.toJson(),
    "disconnected_histories": disconnectedHistories == null ? null : List<dynamic>.from(disconnectedHistories.map((x) => x.toJson())),
    "payment_histories": paymentHistories == null ? null : List<dynamic>.from(paymentHistories.map((x) => x)),
    "line": line == null ? null : line.toJson(),
  };
}

class DisconnectedHistory {
  DisconnectedHistory({
    this.id,
    this.comments,
    this.disconnectedDate,
  });

  String id;
  String comments;
  DateTime disconnectedDate;

  factory DisconnectedHistory.fromJson(Map<String, dynamic> json) => DisconnectedHistory(
    id: json["id"] == null ? null : json["id"],
    comments: json["comments"] == null ? null : json["comments"],
    disconnectedDate: json["disconnected_date"] == null ? null : DateTime.parse(json["disconnected_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "comments": comments == null ? null : comments,
    "disconnected_date": disconnectedDate == null ? null : "${disconnectedDate.year.toString().padLeft(4, '0')}-${disconnectedDate.month.toString().padLeft(2, '0')}-${disconnectedDate.day.toString().padLeft(2, '0')}",
  };
}

class Line {
  Line({
    this.id,
    this.lineName,
  });

  String id;
  String lineName;

  factory Line.fromJson(Map<String, dynamic> json) => Line(
    id: json["id"] == null ? null : json["id"],
    lineName: json["line_name"] == null ? null : json["line_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "line_name": lineName == null ? null : lineName,
  };
}

class SetupBox {
  SetupBox({
    this.serialNumber,
  });

  String serialNumber;

  factory SetupBox.fromJson(Map<String, dynamic> json) => SetupBox(
    serialNumber: json["serial_number"] == null ? null : json["serial_number"],
  );

  Map<String, dynamic> toJson() => {
    "serial_number": serialNumber == null ? null : serialNumber,
  };
}
