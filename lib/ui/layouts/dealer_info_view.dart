import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/blocs/dealer_info_bloc.dart';
import 'package:dealer_app/repositories/events/dealer_info_event.dart';
import 'package:dealer_app/repositories/models/get_branches_model.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/repositories/states/dealer_info_state.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DealerInfoView extends StatelessWidget {
  DealerInfoView({Key? key}) : super(key: key);

  TextEditingController _dealerNameController = TextEditingController();
  TextEditingController _dealerPhoneController = TextEditingController();
  TextEditingController _dealerAddressController = TextEditingController();
  TextEditingController _dealerTimeController = TextEditingController();
  TextEditingController _dealerBranchNameController = TextEditingController();
  TextEditingController _dealerBranchPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Show loading
        EasyLoading.show();
        return DealerInfoBloc();
      },
      child: MultiBlocListener(
        listeners: [
          // Close loading dialog
          BlocListener<DealerInfoBloc, DealerInfoState>(
            listenWhen: (previous, current) {
              return previous is LoadingState;
            },
            listener: (context, state) {
              if (state is LoadedState) {
                EasyLoading.dismiss();
              }
            },
          ),
          BlocListener<DealerInfoBloc, DealerInfoState>(
            listener: (context, state) {
              _dealerNameController.text = state.dealerName;
              _dealerPhoneController.text = state.dealerPhone;
              _dealerAddressController.text = state.dealerAddress;

              var validTime =
                  state.openTime != 'N/A' && state.closeTime != 'N/A';
              _dealerTimeController.text =
                  validTime ? '${state.openTime} - ${state.closeTime}' : '';

              _dealerBranchNameController.text =
                  state.dealerAccountBranch?.name ?? '';
              _dealerBranchPhoneController.text =
                  state.dealerAccountBranch?.phone ?? '';
            },
          ),
        ],
        child: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      elevation: 0,
      title: BlocBuilder<DealerInfoBloc, DealerInfoState>(
        builder: (dealerInfoContext, dealerInfoState) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (authContext, authState) {
            if (authState.user!.roleKey == DealerRoleKey.MAIN_BRANCH.number)
              return chooseDealer();
            else
              return Text(dealerInfoState.dealerName);
          });
        },
      ),
    );
  }

  Widget chooseDealer() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      builder: (context, state) {
        return DropdownSearch<GetBranchesModel>(
          mode: Mode.BOTTOM_SHEET,
          items: state.branches,
          label: null,
          onChanged: (value) {
            if (value != null) {
              context.read<DealerInfoBloc>().add(EventChangeBranch(value.id));
            }
          },
          dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
          itemAsString: (item) {
            return item!.dealerBranchName;
          },
          selectedItem: state.branches.isNotEmpty ? state.branches.first : null,
          emptyBuilder: (context, searchEntry) => Center(
            child: CustomWidgets.customText(text: 'Không có vựa nào'),
          ),
        );
      },
    );
  }

  _body() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
              child: ListView(
            children: [
              if (state.dealerImage != null) _image(),
              ListView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                primary: false,
                shrinkWrap: true,
                children: [
                  CustomWidgets.customText(text: 'Thông tin vựa'),
                  _dealerName(),
                  _dealerPhone(),
                  _dealerAddress(),
                  SizedBox(height: 20),
                  _dealerTime(),
                  if (state.dealerAccountBranch != null)
                    CustomWidgets.customText(text: 'Người quản lý'),
                  if (state.dealerAccountBranch != null) _dealerBranchName(),
                  if (state.dealerAccountBranch != null) _dealerBranchPhone(),
                ],
              ),
            ],
          ));
        else if (state is LoadingState) {
          return Container(
            child: Center(
              child: Text('Đang tải dữ liệu...'),
            ),
          );
        } else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _image() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 200,
          child: Image(
            image: state.dealerImage!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  _dealerName() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Tên vựa phế liệu',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerNameController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerPhone() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Số điện thoại',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerPhoneController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerAddress() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 100,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Địa chỉ',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerAddressController,
            readOnly: true,
            maxLines: null,
            minLines: null,
            expands: true,
          ),
        );
      },
    );
  }

  _dealerTime() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Thời gian hoạt động',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerTimeController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerBranchName() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Tên',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerBranchNameController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerBranchPhone() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Số điện thoại',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerBranchPhoneController,
            readOnly: true,
          ),
        );
      },
    );
  }
}
