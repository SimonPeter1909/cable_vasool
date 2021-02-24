// To parse this JSON data, do
//
//     final addSetupBoxModel = addSetupBoxModelFromJson(jsonString);

import 'dart:convert';

import 'package:cable_vasool/utils/utils.dart';

AddSetupBoxModel addSetupBoxModelFromJson(String str) {
  try{
    return AddSetupBoxModel.fromJson(json.decode(str));
  } catch (e){
    logger.e('json decode error - $e');
    return null;
  }
}

String addSetupBoxModelToJson(AddSetupBoxModel data) => json.encode(data.toJson());

class AddSetupBoxModel {
  AddSetupBoxModel({
    this.createSetupBox,
  });

  CreateSetupBox createSetupBox;

  factory AddSetupBoxModel.fromJson(Map<String, dynamic> json) => AddSetupBoxModel(
    createSetupBox: json["createSetupBox"] == null ? null : CreateSetupBox.fromJson(json["createSetupBox"]),
  );

  Map<String, dynamic> toJson() => {
    "createSetupBox": createSetupBox == null ? null : createSetupBox.toJson(),
  };
}

class CreateSetupBox {
  CreateSetupBox({
    this.setupBox,
  });

  SetupBox setupBox;

  factory CreateSetupBox.fromJson(Map<String, dynamic> json) => CreateSetupBox(
    setupBox: json["setupBox"] == null ? null : SetupBox.fromJson(json["setupBox"]),
  );

  Map<String, dynamic> toJson() => {
    "setupBox": setupBox == null ? null : setupBox.toJson(),
  };
}

class SetupBox {
  SetupBox({
    this.id,
  });

  String id;

  factory SetupBox.fromJson(Map<String, dynamic> json) => SetupBox(
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
  };
}
