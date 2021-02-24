// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) {
  try{
    return LoginModel.fromJson(json.decode(str));
  } catch (e){
    print('json parsing error - $e');
    return null;
  }
}

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.jwt,
    this.user,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  String jwt;
  User user;
  int statusCode;
  String error;
  List<Datum> message;
  List<Datum> data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    jwt: json["jwt"] == null ? "" : json["jwt"],
    user: json["user"] == null ? User() : User.fromJson(json["user"]),
    statusCode: json["statusCode"] == null ? 0 : json["statusCode"],
    error: json["error"] == null ? "" : json["error"],
    message: json["message"] == null ? [] : List<Datum>.from(json["message"].map((x) => Datum.fromJson(x))),
    data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jwt": jwt == null ? null : jwt,
    "user": user == null ? null : user.toJson(),
    "statusCode": statusCode == null ? null : statusCode,
    "error": error == null ? null : error,
    "message": message == null ? null : List<dynamic>.from(message.map((x) => x.toJson())),
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.messages,
  });

  List<Message> messages;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null ? null : List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.id,
    this.message,
  });

  String id;
  String message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"] == null ? null : json["id"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "message": message == null ? null : message,
  };
}

class User {
  User({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.role,
    this.userType,
    this.userOperator,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  Role role;
  String userType;
  Operator userOperator;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    email: json["email"] == null ? null : json["email"],
    provider: json["provider"] == null ? null : json["provider"],
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
    userType: json["user_type"] == null ? null : json["user_type"],
    userOperator: json["operator"] == null ? null : Operator.fromJson(json["operator"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "email": email == null ? null : email,
    "provider": provider == null ? null : provider,
    "confirmed": confirmed == null ? null : confirmed,
    "blocked": blocked == null ? null : blocked,
    "role": role == null ? null : role.toJson(),
    "user_type": userType == null ? null : userType,
    "operator": userOperator == null ? null : userOperator.toJson(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Role {
  Role({
    this.id,
    this.name,
    this.description,
    this.type,
  });

  int id;
  String name;
  String description;
  String type;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
  };
}

class Operator {
  Operator({
    this.id,
    this.operatorName,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String operatorName;
  DateTime createdAt;
  DateTime updatedAt;

  factory Operator.fromJson(Map<String, dynamic> json) => Operator(
    id: json["id"] == null ? null : json["id"],
    operatorName: json["operator_name"] == null ? null : json["operator_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "operator_name": operatorName == null ? null : operatorName,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
