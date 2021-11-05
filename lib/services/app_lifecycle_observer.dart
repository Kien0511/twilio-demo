import 'dart:async';
import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  static final AppLifecycleObserver _observer =
      AppLifecycleObserver._internal();

  AppLifecycleObserver._internal();

  factory AppLifecycleObserver() => _observer;

  final _streamController = StreamController<AppLifecycleState>.broadcast();
  final _inCallComingController = StreamController<dynamic>.broadcast();
  final _test = StreamController<bool>.broadcast();

  Stream<AppLifecycleState> get status async* {
    yield* _streamController.stream;
  }

  Stream<dynamic> get inCallComingStatus async* {
    yield* _inCallComingController.stream;
  }

  Stream<bool> get testStatus async* {
    yield* _test.stream;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    _streamController.add(state);
    _test.add(true);
  }

  void addInComingCallState(dynamic event) {
    print("addInComingCallState $event");
    _inCallComingController.add(event);
    // _test.add(true);
  }
}
