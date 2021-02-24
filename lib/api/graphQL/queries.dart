import 'package:flutter/cupertino.dart';

class Queries {
  static String createBrand(
      {@required String brandName, @required String brandLink}) {
    return """
    mutation {
  createBrand(input: {
    data: {
      brand_name : "$brandName",
      brand_link : "$brandLink"
    }
  }){
    brand {
      id
    }
  }
}
    """;
  }

  static String addSetupBox(
      {@required String serialNumber,
      @required int operatorId,
      @required int providerId}) {
    return """
    mutation addSetupBox {
  createSetupBox(
    input : {
      data : {
        serial_number : "$serialNumber"
        operator : $operatorId
        setup_box_provider : $providerId
      }
    }
  ) {
    setupBox{
      id
    }
  }
}
    """;
  }

  static String addConnection(
      {@required String customerName,
      @required String connectionNumber,
      @required String connectionAddedDate,
      @required int operatorId,
      @required int lineId,
      @required int dueAmount,
      @required int setUpBoxId}) {
    return """
    mutation addConnection {
  createConnection(
    input: {
      data: {
        customer_name: "$customerName"
        connection_number: "$connectionNumber"
        due_amount: $dueAmount
        connection_added_date : "$connectionAddedDate"
        operator : $operatorId
        line : $lineId
        setup_box : $setUpBoxId
        disconnected : false
      }
    }
  ) {
    connection {
      id
    }
  }
}
    """;
  }

  static String getDashboard() {
    return """
    query dashboard(
  \$operator_id: Int!
  \$payment_year: Int!
  \$payment_month: Int!
  \$payment_date: String!
) {
  totalConnections: connectionsConnection(
    where: { operator: { id: \$operator_id } }
  ) {
    aggregate {
      sum {
        due_amount
      }
      count
    }
  }
  paymentCollected: paymentHistoriesConnection(
    where: {
      payment_year: \$payment_year
      payment_month: \$payment_month
      operator: { id: \$operator_id }
    }
  ) {
    aggregate {
      sum {
        amount_collected
      }
    }
  }
  connectionsCollected: connectionsConnection(
    where: {
      payment_histories: {
        payment_year: \$payment_year
        payment_month: \$payment_month
        operator: { id: \$operator_id }
      }
    }
  ) {
    aggregate {
      count
    }
  }
  todayPaymentCollected: paymentHistoriesConnection(
    where: {
      payment_date: \$payment_date
      operator: { id: \$operator_id }
    }
  ) {
    aggregate {
      sum {
        amount_collected
      }
    }
  }
  todayConnectionsCollected: connectionsConnection(
    where: {
      payment_histories: {
        payment_date: \$payment_date
        operator: { id: \$operator_id }
      }
    }
  ) {
    aggregate {
      count
    }
  }
  totalSetupBox: setupBoxesConnection(
    where: { operator: { id: \$operator_id } }
  ) {
    aggregate {
      count
    }
  }
  activeSetupBox: setupBoxesConnection(
    where: { operator: { id: \$operator_id }, connections_contains: "" }
  ) {
    aggregate {
      count
    }
  }
  lines: lines {
    id
    line_name
  }
  connectionsConnection {
    groupBy {
      line {
        key
        connection {
          aggregate {
            count
            sum {
              due_amount
            }
          }
        }
      }
    }
  }
  paymentHistoriesConnection(
    where: { 
      payment_year: \$payment_year
      payment_month: \$payment_month
      operator: { id: \$operator_id } }
  ) {
    groupBy {
      line {
        key
        connection {
          aggregate {
            count
            sum {
              amount_collected
            }
          }
        }
      }
    }
  }
}
    """;
  }

  static String getConnectionListByLine(){
    return """
query getConnectionsByLine(\$lineId: Int!, \$page: Int!, \$payment_year: Int!, \$payment_month: Int!,){
  connections(limit: 10, start: \$page,where:{
    line :{
      id : \$lineId
    }
  }){
    id
    customer_name
    connection_number
    connection_added_date
    due_amount
    setup_box{
      serial_number
    }
    disconnected_histories(where : {
      disconnected_year : \$payment_year,
      disconnected_month : \$payment_month
    }){
      id
      comments
      disconnected_date
    }
    payment_histories (where : {
      payment_year : \$payment_year,
      payment_month : \$payment_month
    }) {
      id
      payment_year
      payment_month
      payment_date
      amount_collected
    }
    customer_name
    line{
      id
      line_name
    }
  }
}
    """;
  }

}
