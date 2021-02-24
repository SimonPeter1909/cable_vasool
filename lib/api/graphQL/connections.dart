import 'package:cable_vasool/api/config.dart';
import 'package:cable_vasool/utils/SharedPreferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GQLConnection {
  static final HttpLink httpLink =
      HttpLink(uri: '${Config.baseURL}graphql');

  static AuthLink authLink = AuthLink(
    getToken: () async => '${await Preferences.getJWT()}',
  );

  static Link link = authLink.concat(httpLink);

  static GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }
}
