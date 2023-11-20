import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';

part 'gtin_events_states.dart';

class GtinBloc extends Bloc<GtinEvent, GtinState> {
  GtinBloc() : super(GtinInitialState()) {
    // Handle Events
    on<GtinGetDataEvent>((event, emit) async {
      emit(GtinLoadingState());
      try {
        final data = await BaseApiService.getData(
          event.context,
          gtin: event.gtin,
        );
        emit(GtinSuccessState(model: data));
      } catch (error) {
        emit(GtinErrorState(message: error.toString()));
      }
    });
  }
}
