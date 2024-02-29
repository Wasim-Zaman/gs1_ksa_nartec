part of 'gtin_cubit.dart';

class GtinState {}

class GtinInitialState extends GtinState {}

class GtinLoadingState extends GtinState {}

class GtinLoadedState extends GtinState {
  final ProductContentsListModel productContentsListModel;
  GtinLoadedState({required this.productContentsListModel});
}

class GtinErrorState extends GtinState {
  final String error;
  GtinErrorState({required this.error});
}
