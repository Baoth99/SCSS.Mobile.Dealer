import 'package:dealer_app/blocs/login_bloc.dart';
import 'package:dealer_app/repositories/events/login_event.dart';
import 'package:dealer_app/repositories/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(initialState: LoginState()),
      // child: _Body(),
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.process == Process.processing) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          backgroundColor: Colors.black87,
                          content: CircularProgressIndicator(),
                        ));
                  },
                );
              }
              if (state.process == Process.finishProcessing) {
                Navigator.of(context).pop();
              }
            },
            child: FloatingActionButton(
              onPressed: () {
                context.read<LoginBloc>().add(EventLoginButtonSubmmited());
              },
            ),
          ),
        );
      }),
    );
  }
}

// class _Body extends StatelessWidget {
//   const _Body({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 200,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//               bottom: 100,
//             ),
//             child: Image.asset(
//               LoginLayoutConstants.loginLogoImagePath,
//               fit: BoxFit.contain,
//               height: 270.h,
//             ),
//           ),
//           CustomText(
//             text: LoginLayoutConstants.loginToContinue,
//             color: AppColors.greyFF9098B1,
//             fontSize: 35.sp,
//           ),
//           const _Form(),
//           CustomTextButton(
//             text: LoginLayoutConstants.forgetPassword,
//             onPressed: () {},
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(
//               horizontal: 35.w,
//               vertical: 100.h,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Divider(
//                     thickness: 3.h,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                   ),
//                   child: CustomText(
//                     text: LoginLayoutConstants.or,
//                     color: AppColors.greyFF9098B1,
//                     fontSize: 33.sp,
//                   ),
//                 ),
//                 Expanded(
//                   child: Divider(
//                     thickness: 3.h,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           CustomButton(
//             text: LoginLayoutConstants.signup,
//             onPressed: () {
//               _navigateToSignup(context);
//             },
//             fontSize: 44.sp,
//             color: AppColors.orangeFFF5670A,
//             width: double.infinity,
//             height: 100.h,
//             padding: EdgeInsets.symmetric(
//               horizontal: 180.w,
//             ),
//             circularBorderRadius: 15.0.r,
//           ),
//         ],
//       ),
//     );
//   }

//   // Navigate the screen to first screen of signup screen
//   void _navigateToSignup(BuildContext context) {
//     Navigator.pushNamed(context, Routes.signupPhoneNumber);
//   }
// }

// class _Form extends StatelessWidget {
//   const _Form({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//               top: 55.h,
//             ),
//             child: BlocBuilder<LoginBloc, LoginState>(
//               buildWhen: (p, c) => p.phoneNumber.status != c.phoneNumber.status,
//               builder: (context, state) {
//                 return CustomBorderTextFormField(
//                   onChanged: _onPhoneNumberChanged(context),
//                   style: _getInputFieldTextStyle(),
//                   labelText: LoginLayoutConstants.phoneNumber,
//                   commonColor: AppColors.greenFF61C53D,
//                   keyboardType: TextInputType.phone,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly,
//                   ],
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 60.0.w,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 45.0.w,
//                     vertical: 42.0.h,
//                   ),
//                   cirularBorderRadius: 15.0.r,
//                   errorText: state.phoneNumber.invalid
//                       ? LoginLayoutConstants.errorPhoneNumber
//                       : null,
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(
//               top: 30.h,
//             ),
//             child: BlocBuilder<LoginBloc, LoginState>(
//               buildWhen: (p, c) => p.password.status != c.password.status,
//               builder: (context, state) {
//                 return CustomBorderTextFormField(
//                   onChanged: _onPasswordChanged(context),
//                   style: _getInputFieldTextStyle(),
//                   labelText: LoginLayoutConstants.password,
//                   commonColor: AppColors.greenFF61C53D,
//                   keyboardType: TextInputType.visiblePassword,
//                   obscureText: true,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 60.0.w,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 45.0.w,
//                     vertical: 42.0.h,
//                   ),
//                   cirularBorderRadius: 15.0.r,
//                   errorText: state.password.invalid
//                       ? LoginLayoutConstants.errorPassword
//                       : null,
//                 );
//               },
//             ),
//           ),
//           CustomButton(
//             text: LoginLayoutConstants.login,
//             fontSize: 45.sp,
//             onPressed: _onPressed(context),
//             color: AppColors.greenFF61C53D,
//             height: 130.h,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(
//               horizontal: 60.w,
//               vertical: 50.0.h,
//             ),
//             circularBorderRadius: 15.0.r,
//           ),
//         ],
//       ),
//     );
//   }

//   void Function() _onPressed(BuildContext context) {
//     return () {
//       context.read<LoginBloc>().add(
//             LoginButtonSubmmited(),
//           );
//     };
//   }

//   Function(String) _onPhoneNumberChanged(BuildContext context) {
//     return (value) {
//       context.read<LoginBloc>().add(
//             LoginPhoneNumberChanged(
//               phoneNumber: value,
//             ),
//           );
//     };
//   }

//   Function(String) _onPasswordChanged(BuildContext context) {
//     return (value) {
//       context.read<LoginBloc>().add(
//             LoginPasswordChanged(
//               password: value,
//             ),
//           );
//     };
//   }

//   TextStyle _getInputFieldTextStyle() {
//     return TextStyle(
//       fontSize: 52.sp,
//       fontWeight: FontWeight.w400,
//     );
//   }
// }
