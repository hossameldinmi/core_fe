class DateTimeWrapper implements IDateTimeWrapper {
  @override
  DateTime now() => DateTime.now();
}

abstract class IDateTimeWrapper {
  DateTime now();
}
