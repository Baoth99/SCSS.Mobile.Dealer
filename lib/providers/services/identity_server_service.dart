import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/identity_server_network.dart';
import 'package:dealer_app/repositories/models/gender_model.dart';
import 'package:dealer_app/repositories/states/profile_state.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerService {
  Future<ProfileState?> getProfile();
  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword);
}

class IdentityServerServiceImpl implements IdentityServerService {
  late final IdentityServerNetwork _identityServerNetwork;

  IdentityServerServiceImpl({IdentityServerNetwork? identityServerNetwork}) {
    _identityServerNetwork =
        identityServerNetwork ?? getIt.get<IdentityServerNetwork>();
  }
  @override
  Future<ProfileState?> getProfile() async {
    Client client = Client();
    ProfileState? result;
    var responseModel = await _identityServerNetwork
        .getAccountInfo(client)
        .whenComplete(() => client.close());
    var m = responseModel.resData;
    if (m != null) {
      String imageUrl = Symbols.empty;
      if (m.image != null && m.image!.isNotEmpty) {
        imageUrl = NetworkUtils.getUrlWithQueryString(
            CustomApiUrl.imageGet, {'imageUrl': m.image!});
      }
      result = ProfileState(
        id: m.id,
        name: m.name ?? Symbols.empty,
        address: m.address,
        birthDate: m.birthDate == null
            ? null
            : CommonUtils.convertDDMMYYYToDateTime(m.birthDate!),
        email: m.email,
        gender: m.gender == 1 ? Gender.male : Gender.female,
        image: imageUrl,
        phone: m.phone ?? Symbols.empty,
        totalPoint: m.totalPoint ?? 0,
        idCard: m.idCard ?? Symbols.empty,
      );
    }

    return result;
  }

  @override
  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword) async {
    Client client = Client();

    var result = await _identityServerNetwork
        .updatePassword(
          id,
          oldPassword,
          newPassword,
          client,
        )
        .whenComplete(() => client.close());

    return result;
  }
}
