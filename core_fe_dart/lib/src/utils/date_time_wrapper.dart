class DateTimeWrapperImpl implements DateTimeWrapper {
  @override
  DateTime now() => DateTime.now();
}

abstract class DateTimeWrapper {
  DateTime now();
}
