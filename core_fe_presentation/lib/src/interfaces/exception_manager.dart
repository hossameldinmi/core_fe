import 'package:core_fe_presentation/state.dart';

abstract class ExceptionManager {
  Future<void> handle(Exception ex, PageViewModelBase pageViewModelBase, {CusomeHandling handling});
}

typedef CusomeHandling = Future<void> Function(Exception, PageViewModelBase);
