import 'package:intl/intl.dart';

final dateFormatter = DateFormat('yyyy-M-dTH:m:s'); // 2021-04-27T13:35:51.848+00:00

DateTime dateTimeFromJson(String dateTime) {
  return dateFormatter.parse(dateTime);
}

String dateTimeToJson(DateTime dateTime) {
  if ( dateTime == null ) {
    return null;
  }
  return parseDateTime(dateTime);
}

String parseDateTime(DateTime dateTime) {
  if ( dateTime == null ) {
    return null;
  }
  return dateFormatter.format(dateTime);
}