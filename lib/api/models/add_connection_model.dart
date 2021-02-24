// To parse this JSON data, do
//
//     final addConnectionModel = addConnectionModelFromJson(jsonString);

import 'dart:convert';

import 'package:cable_vasool/utils/utils.dart';

AddConnectionModel addConnectionModelFromJson(String str) {
  try{
    return AddConnectionModel.fromJson(json.decode(str));
  } catch (e){
    logger.e('json parsing error - $e');
    return null;
  }
}

String addConnectionModelToJson(AddConnectionModel data) => json.encode(data.toJson());

class AddConnectionModel {
  AddConnectionModel({
    this.createConnection,
  });

  CreateConnection createConnection;

  factory AddConnectionModel.fromJson(Map<String, dynamic> json) => AddConnectionModel(
    createConnection: json["createConnection"] == null ? null : CreateConnection.fromJson(json["createConnection"]),
  );

  Map<String, dynamic> toJson() => {
    "createConnection": createConnection == null ? null : createConnection.toJson(),
  };
}

class CreateConnection {
  CreateConnection({
    this.connection,
  });

  Connection connection;

  factory CreateConnection.fromJson(Map<String, dynamic> json) => CreateConnection(
    connection: json["connection"] == null ? null : Connection.fromJson(json["connection"]),
  );

  Map<String, dynamic> toJson() => {
    "connection": connection == null ? null : connection.toJson(),
  };
}

class Connection {
  Connection({
    this.id,
  });

  String id;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
  };
}
