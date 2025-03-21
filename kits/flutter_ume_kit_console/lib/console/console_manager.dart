import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

const int maxLine = 1000;

class ConsoleManager {
  static final Queue<Tuple2<DateTime, String>> _logData = Queue();
  static StreamController? _logStreamController;
  static DebugPrintCallback? _originalDebugPrint;

  static Queue<Tuple2<DateTime, String>> get logData => _logData;

  static StreamController? get streamController => _getLogStreamController();

  static StreamController? _getLogStreamController() {
    if (_logStreamController == null) {
      _logStreamController = StreamController.broadcast();
      var transformer =
          StreamTransformer<dynamic, Tuple2<DateTime, String>>.fromHandlers(
              handleData: (str, sink) {
        final now = DateTime.now();
        sink.add(Tuple2(now, str.toString()));
      });

      _logStreamController!.stream.transform(transformer).listen((value) {
        if (_logData.length < maxLine) {
          _logData.addFirst(value);
        } else {
          _logData.removeLast();
        }
      });
    }
    return _logStreamController;
  }

  static void redirectAllLogs() {
    if (_originalDebugPrint == null) {
      _originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        _sendLog(message);
        _originalDebugPrint?.call(message, wrapWidth: wrapWidth);
      };
    }

    runZonedGuarded(
        () {
          // Запускаємо код в ізольованій зоні, де переоприділяємо print
        },
        (error, stackTrace) {},
        zoneSpecification: ZoneSpecification(
          print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
            _sendLog(line);
            parent.print(zone, line); // Відправляємо стандартний print
          },
        ));
  }

  static void _sendLog(String? message) {
    if (message == null) return;
    streamController!.sink.add(message);
  }

  static void logMessage(String message) {
    log(message); // Використання dart:developer
    _sendLog(message);
  }

  static void clearLog() {
    logData.clear();
    _logStreamController!.add('UME CONSOLE == ClearLog');
  }

  @visibleForTesting
  static void clearRedirects() {
    debugPrint = _originalDebugPrint!;
    _originalDebugPrint = null;
  }
}
