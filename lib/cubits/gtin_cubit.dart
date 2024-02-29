import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';

part 'gtin_states.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitialState());

  void getGtinData(BuildContext context, String gtin) async {
    emit(GtinLoadingState());
    try {
      // Call the API
      final productContentsListModel =
          await BaseApiService.getData(context, gtin: gtin);
      emit(GtinLoadedState(productContentsListModel: productContentsListModel));
    } catch (error) {
      emit(GtinErrorState(error: error.toString()));
    }
  }
}
