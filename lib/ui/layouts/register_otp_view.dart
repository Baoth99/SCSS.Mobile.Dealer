import 'package:dealer_app/blocs/register_otp_bloc.dart';
import 'package:dealer_app/repositories/events/register_otp_event.dart';
import 'package:dealer_app/repositories/states/register_otp_state.dart';
import 'package:dealer_app/ui/widgets/buttons.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterOTPView extends StatelessWidget {
  RegisterOTPView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return BlocProvider(
      create: (context) {
        return RegisterOTPBloc(
            initialState: RegisterOTPState(phone: _argumentMap['phone']));
      },
      child: BlocListener<RegisterOTPBloc, RegisterOTPState>(
        listener: (context, state) {
          if (state.process == Process.processing) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          } else if (state.process == Process.processed) {
            Navigator.of(context).pop();
          } else if (state.process == Process.error) {
            _showSnackBar(context, CustomTexts.checkOTPErrorMessage);
          } else if (state.process == Process.valid) {
            Navigator.of(context).pushNamed(CustomRoutes.registerPersonalInfo,
                arguments: {'phone': state.phone});
          }
        },
        child: BlocBuilder<RegisterOTPBloc, RegisterOTPState>(
          builder: (context, state) {
            return Scaffold(
              body: _body(),
            );
          },
        ),
      ),
    );
  }

  _showSnackBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  _body() {
    return BlocBuilder<RegisterOTPBloc, RegisterOTPState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 100, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _logo(),
                customText(text: CustomTexts.otpMessage + ' ' + state.phone),
                _otpField(),
                _submitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  _logo() {
    return
        //logo
        Image.asset(
      CustomAssets.logo,
      height: 100,
      width: 100,
    );
  }

  _otpField() {
    return BlocBuilder<RegisterOTPBloc, RegisterOTPState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                height: 90,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => context
                      .read<RegisterOTPBloc>()
                      .add(EventOTPChanged(otp: value)),
                  validator: (value) {
                    if (!state.isOTPValid) return CustomTexts.invalidOTP;
                  },
                ),
              ),
            ),
            // SizedBox(
            //   height: 90,
            //   width: 50,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
            // SizedBox(
            //   height: 90,
            //   width: 50,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
            // SizedBox(
            //   height: 90,
            //   width: 50,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
            // SizedBox(
            //   height: 90,
            //   width: 50,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
            // SizedBox(
            //   height: 90,
            //   width: 50,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
          ],
        );
      },
    );
  }

  _submitButton() {
    return BlocBuilder<RegisterOTPBloc, RegisterOTPState>(
      builder: (context, state) {
        return customElevatedButton(
          context,
          CustomTexts.next,
          () {
            if (_formKey.currentState!.validate())
              context.read<RegisterOTPBloc>().add(EventCheckOTP());
          },
        );
      },
    );
  }
}
