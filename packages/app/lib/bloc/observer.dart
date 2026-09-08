import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

final log = Logger("main");

class Observer extends BlocObserver {
  const Observer();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log.fine('${bloc.runtimeType} $change');
  }
}
