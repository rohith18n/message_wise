import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/Service/status/status_services.dart';

import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitialState()) {
    on<AddStatusEvent>((event, emit) async {
      // start the loading
      emit(StatusLoadingState());
      log('state is StatusLoadingState');
      try {
        // upload to storage and db
        String res = await FireStoreStatusMethods().uploadStatus(
          event.description,
          event.file,
          event.uid,
          event.username,
          event.profImage,
        );
        if (res == "success") {
          emit(StatusAddedState());
          log('state is StatusAddedState');
        } else {
          emit(StatusErrorState(error: res));
          log('state is StatusErrorState');
        }
      } catch (err) {
        StatusErrorState(error: err.toString());
        log('state is StatusErrorState');
      }
      emit(StatusAddedState());
      log('state is StatusAddedState');
    });
  }
}
