part of 'gtin_bloc.dart';

class GtinEvent {}

class GtinGetDataEvent extends GtinEvent {
  final String gtin;
  final BuildContext context;
  GtinGetDataEvent(this.context, {required this.gtin});
}

// States
class GtinState {}

class GtinInitialState extends GtinState {}

class GtinLoadingState extends GtinState {}

class GtinSuccessState extends GtinState {
  final ProductContentsListModel? model;
  GtinSuccessState({required this.model});
}

class GtinErrorState extends GtinState {
  final String message;
  GtinErrorState({required this.message});
}
