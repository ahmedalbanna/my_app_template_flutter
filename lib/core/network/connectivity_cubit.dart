import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityCubit(this._connectivity) : super(true) {
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      emit(!results.contains(ConnectivityResult.none));
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    emit(!results.contains(ConnectivityResult.none));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
