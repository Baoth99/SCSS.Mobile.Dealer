import 'package:dealer_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

class RegisterCompleteView extends StatelessWidget {
  const RegisterCompleteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: _body(_argumentMap),
    );
  }

  _body(argumentMap) {
    return SingleChildScrollView(
      child: Column(
        children: [
          customText(
              text: 'Xin chào ${argumentMap['name']}',
              alignment: Alignment.center),
          customText(
              text:
                  'Bạn đã đăng ký làm đối tác chủ vựa phế liệu của VeChaiXANH thành công',
              alignment: Alignment.center),
          customText(
              text:
                  'Vui lòng lên văn phòng VeChaiXANH để hoàn tất thủ tục để bạn có thể sử dụng dịch vụ của chúng tôi',
              alignment: Alignment.center),
        ],
      ),
    );
  }
}
