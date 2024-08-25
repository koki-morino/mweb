import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:memkept/app.dart';
import 'package:memkept/bloc/observer.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[${record.time}] ${record.level.name}: ${record.message}');
  });

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('Noto_Sans_JP/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Noto_Sans_JP'], license);
  });

  Bloc.observer = const Observer();

  runApp(const MyApp());
}
