export 'Fluttertoast.dart';
export 'navigator.dart';
export 'PackageInfo.dart';
export 'SharedPreferences.dart';

import 'package:logger/logger.dart';

Logger logger = Logger(
    printer: PrettyPrinter(colors: true, printEmojis: true, printTime: true));


final String rupeeSign = '₹';

///Common Enums
enum DashboardState {loading, loaded, error}
enum ListState {loading, loaded, empty, error}
enum FormState {loading, loaded, error, success}