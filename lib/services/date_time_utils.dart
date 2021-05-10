import 'package:intl/intl.dart';

final dateFormatter = DateFormat('d-M-yyyy H:m:s');

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