import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity/connectivity.dart';
part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) {
      if (event is InternetLostEvent){
         emit(InternetLostState());
      }else{
         emit(InternetGainedState());
      }
      // TODO: implement event handler
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }else{
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
