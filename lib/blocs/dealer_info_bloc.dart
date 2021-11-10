import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/transaction_service.dart';
import 'package:dealer_app/repositories/events/dealer_info_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/dealer_info_handler.dart';
import 'package:dealer_app/repositories/models/get_branches_model.dart';
import 'package:dealer_app/repositories/models/get_dealer_info_model.dart';
import 'package:dealer_app/repositories/states/dealer_info_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DealerInfoBloc extends Bloc<DealerInfoEvent, DealerInfoState> {
  final _dealerInfoHandler = getIt.get<IDealerInfoHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  DealerInfoBloc() : super(LoadingState.noData()) {
    add(EventInitData());
  }

  late String _mainBrannchId;

  @override
  Stream<DealerInfoState> mapEventToState(DealerInfoEvent event) async* {
    if (event is EventInitData) {
      try {
        GetDealerInfoModel getDealerInfoModel =
            await _dealerInfoHandler.getDealerInfo();

        List<GetBranchesModel> branches =
            await _dealerInfoHandler.getBranches();
        branches.insert(
          0,
          GetBranchesModel(
              id: getDealerInfoModel.id,
              dealerBranchName: getDealerInfoModel.dealerName,
              dealerBranchImageUrl: getDealerInfoModel.dealerImageUrl,
              dealerBranchAddress: getDealerInfoModel.dealerAddress),
        );

        // Get image
        ImageProvider? image;
        if (getDealerInfoModel.dealerImageUrl.isNotEmpty)
          image = await _dataHandler.getImageBytes(
              imageUrl: getDealerInfoModel.dealerImageUrl);

        // Set main branch id
        _mainBrannchId = getDealerInfoModel.id;

        yield LoadedState(
          branches: branches,
          selectedId: getDealerInfoModel.id,
          dealerImage: image,
          dealerName: getDealerInfoModel.dealerName,
          dealerAddress: getDealerInfoModel.dealerAddress,
          dealerPhone: getDealerInfoModel.dealerPhone,
          openTime: getDealerInfoModel.openTime,
          closeTime: getDealerInfoModel.closeTime,
          dealerAccountBranch: null,
        );
      } catch (e) {
        print(e);
        yield ErrorState.noData(
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventChangeBranch) {
      // If main branch is not selected
      if (event.branchId != _mainBrannchId) {
        var branchInfo =
            await _dealerInfoHandler.getBranchDetail(id: event.branchId);

        // Get image
        ImageProvider? image;
        if (branchInfo.dealerBranchImageUrl.isNotEmpty)
          image = await _dataHandler.getImageBytes(
              imageUrl: branchInfo.dealerBranchImageUrl);

        yield new LoadedState(
          branches: state.branches,
          selectedId: event.branchId,
          dealerImage: image,
          dealerName: branchInfo.dealerBranchName,
          dealerAddress: branchInfo.dealerBranchAddress,
          dealerPhone: branchInfo.dealerBranchPhone,
          openTime: branchInfo.dealerBranchOpenTime,
          closeTime: branchInfo.dealerBranchCloseTime,
          dealerAccountBranch: branchInfo.dealerAccountBranch,
        );
      }
      // If main branch is selected
      else {
        GetDealerInfoModel getDealerInfoModel =
            await _dealerInfoHandler.getDealerInfo();

        // Get image
        ImageProvider? image;
        if (getDealerInfoModel.dealerImageUrl.isNotEmpty)
          image = await _dataHandler.getImageBytes(
              imageUrl: getDealerInfoModel.dealerImageUrl);

        yield LoadedState(
          branches: state.branches,
          selectedId: getDealerInfoModel.id,
          dealerImage: image,
          dealerName: getDealerInfoModel.dealerName,
          dealerAddress: getDealerInfoModel.dealerAddress,
          dealerPhone: getDealerInfoModel.dealerPhone,
          openTime: getDealerInfoModel.openTime,
          closeTime: getDealerInfoModel.closeTime,
          dealerAccountBranch: null,
        );
      }
    }
  }
}