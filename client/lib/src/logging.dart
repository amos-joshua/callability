import 'package:flutter/foundation.dart';
import 'package:logging_flutter/logging_flutter.dart';

void initializeLogging() {
  Flogger.init();
  if (kDebugMode){
    Flogger.registerListener(
          (record) => print('${record.printable()}${record.stackTrace != null ? '\n${record.stackTrace}' : ''}'),
    );
  }
  Flogger.registerListener(
        (record) => LogConsole.add(
      OutputEvent(record.level, [record.printable()]),
      bufferSize: 1000, // Remember the last X logs
    ),
  );
}
