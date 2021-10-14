import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:intl/intl.dart';

class BotNavUtils {
  static const int stateHomeIndex = 0;
  static const int stateNotificationIndex = 1;
  static const int stateCategoryIndex = 3;
  static const int stateHistoryIndex = 4;
}

class CustomTexts {
  static const String categoryScreenTitle = 'Danh mục';
  static const String addCategoryScreenTitle = 'Thêm danh mục';
  static const String categoryDetailScreenTitle = 'Chi tiết';
  static const String createTransactionScreenTitle = 'Tạo giao dịch';
  //login_view
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String loginButton = 'Đăng nhập';
  static const String phoneError = 'Số điện thoại không hợp lệ';
  static const String phoneBlank = 'Số điện thoại không được để trống';
  static const String passwordLabel = 'Mật khẩu';
  static const String phoneLabel = 'Số điện thoại';
  static const String wrongPasswordOrPhone =
      'Số điện thoại hoặc mật khẩu không chính xác';
  static const String loginError =
      'Đăng nhập thất bại, xin thử lại sau vài phút';
  static const String forgetPassword = 'Bạn quên mật khẩu?';
  static const String forgetPasswordTextButton = 'Lấy lại mật khẩu';
  static const String register = 'Bạn chưa có tài khoản?';
  static const String registerTextButton = 'Đăng ký';
  //api id4
  static const String apiUrlTokenLink = 'connect/token';
  //app api
  static const String apiUrlDealerInfoLink =
      '/api/v3/dealer/account/dealer-info';
  static const String apiUrlPutDeviceId = '/api/v3/dealer/account/device-id';
  static const String apiUrlGetPromotions = '/api/v3/promotion/get';
  static const String apiUrlGetScrapCategories =
      '/api/v3/trans/scrap-categories';
  static const String apiUrlGetScrapCategoryDetails =
      '/api/v3/trans/scrap-category-detail';
  //api throws
  static const String loginFailedException = 'Login failed';
  static const String fetchTokenFailedException = 'Failed to fetch token';
  static const String fetchDealerInfoFailedException =
      'Failed to fetch user info';
  static const String putDeviceIdFailedException = 'Failed to put device Id';
  static const String getPromotionsFailedException = 'Failed to get promotions';
  static const String getScrapCategoriesFailedException =
      'Failed to get scrap categories';
  static const String getScrapCategoryDetailsFailedException =
      'Failed to get scrap category details';
  //register
  static const String registerWelcomeText =
      'Xin chào, số điện thoại của bạn là?';
  static const String next = 'Tiếp';
  static const String resendOTPButton = 'Gửi lại mã số';
  static const String resendOTPText = 'Bạn chưa nhận được mã số?';
  static const String otpMessage =
      'Một mã số gồm 6 chữ số vừa được gửi đến số điện thoại';
  static const String otpErrorMessage =
      'Gửi mã số thất bại, xin đợi 5 phút và thử lại';
  static const String invalidOTP = 'Mã số không hợp lệ';
  static const String checkOTPErrorMessage =
      'Đã có lỗi xảy ra, xin đợi 5 phút và thử lại';
  static const String appBarPersonalInfoText = 'Thông tin cá nhân';
  static const String nameLabel = 'Họ và Tên';
  static const String invalidName = 'Tên không hợp lệ';
  static const String idLabel = 'CMND/CCCD/Bằng lái xe';
  static const String idBlank = 'Mục này không được để trống';
  static const String birthDateLabel = 'Ngày sinh';
  static const String birthDatePickerHelpText = 'Chọn ngày sinh';
  static const String addressLabel = 'Địa chỉ';
  static const String sexLabel = 'Giới tính';
  static const String rePasswordLabel = 'Nhập lại mật khẩu';
  static const String rePasswordError = 'Nhập lại mật khẩu không khớp';
  static const String rePasswordBlank = 'Nhập lại mật khẩu không được để trống';
  static const String passwordError = 'Mật khẩu phải chứa ít nhất 6 ký tự';
  static const String passwordBlank = 'Mật khẩu không được để trống';
  static const String nameBlank = 'Tên không được để trống';
  static const String appBarBranchOptionText = 'Thông tin vựa';
  static const String isBranchText =
      'Vựa mới của bạn có phải là chi nhánh của một vựa khác đã đăng ký trước đó không?';
  static const String mainBranchIdLabel = 'Tên vựa chính';
  static const String mainBranchIdBlank = 'Tên vựa chính không được để trống';
  static const String storeNameLabel = 'Tên vựa';
  static const String storePhoneLabel = 'Số điện thoại vựa';
  static const String storeAddressLabel = 'Địa chỉ vựa';
  static const String storeNameBlank = 'Tên vựa không được để trống';
  static const String storePhoneBlank = 'Số điện thoại vựa không được để trống';
  static const String storePhoneError = 'Số điện thoại vựa không hợp lệ';
  static const String storeAddressBlank = 'Địa chỉ vựa không được để trống';
  static const String appBarStoreInfoText = 'Thông tin vựa';
  static const String cameraText = 'Máy ảnh';
  static const String galleryText = 'Thư viện';
  static const String storeFrontImageText = 'Ảnh chụp mặt trước cửa hàng';
  static const String logoutButtonText = 'Đăng xuất';
  static const String registerCompleteGreeting = 'Xin chào ';
  static const String registerCompleteCongrat =
      'Bạn đã đăng ký làm đối tác chủ vựa phế liệu của VeChaiXANH thành công';
  static const String registerCompleteNote =
      'Vui lòng lên văn phòng VeChaiXANH để hoàn tất thủ tục để bạn có thể sử dụng dịch vụ của chúng tôi';
  //create transaction
  static const String cancelButtonText = 'Huỷ';
  static const String createTransactionButtonText = 'Tạo giao dịch';
  static const String detailText = 'Chi tiết';
  static const String subTotalText = 'Tạm tính';
  static const String totalText = 'Khách hàng nhận';
  static const String promotionText = 'Khuyến mãi';
  static const String collectorPhoneLabel = 'SĐT người bán';
  static const String collectorNameLabel = 'Tên người bán';
  static const String calculatedByUnitPriceText = 'Tính theo đơn giá';
  static const String calculatedByUnitPriceExplainationText =
      'Tính tiền bằng đơn giá nhân số lượng';
  static const String scrapTypeLabel = 'Loại phế liệu';
  static const String unitLabel = 'Đơn vị';
  static const String quantityLabel = 'Số lượng';
  static const String unitPriceLabel = 'Đơn giá';
  static const String totalLabel = 'Tổng cộng';
  static const String vndSymbolText = 'đ';
  static String promotionAppliedText({required String promotionId}) =>
      '* Khuyến mãi $promotionId đang được áp dụng';
  static const String generalErrorMessage =
      'Đã có lỗi xảy ra, vui lòng thử lại';
  static const String totalBlank = 'Tổng cộng không được để trống';
  static const String quantityBlank = '$quantityLabel không được để trống';
  static const String quantityZero = '$quantityLabel phải lớn hơn 0';
  static const String unitPriceBlank = '$unitPriceLabel không được để trống';
  static const String unitPriceNegative = '$unitPriceLabel không được là số âm';
  static const String scrapTypeBlank = '$scrapTypeLabel không được để trống';
  static const String emptyString = '';
  static const String promotionNotAppliedText =
      'Không có khuyến mãi nào được áp dụng';
  static const String addScrapButtonText = 'Thêm phế liệu';
  static const String totalNegative = '$totalLabel không được là số âm';
  static const String scrapCategoryUnitBlank = '$unitLabel không được để trống';
  static const String zeroString = '0';
}

class CustomFormats {
  static const String birthday = 'dd/MM/yyyy';
  static NumberFormat numberFormat = NumberFormat('###,###');
  static NumberFormat currencyFormat =
      NumberFormat('###,### ${CustomTexts.vndSymbolText}');
}

class CustomRegexs {
  static const String phoneRegex = r'^0[0-9]{9}$';
  static const String passwordRegex = r'^.{6,}$';
  static const String otpRegex = r'^[0-9]{6}$';
}

class CustomAssets {
  static const String logo = 'assets/images/vua_192x192.png';
}

class CustomRoutes {
  static const String botNav = '/navBar';
  static const String addCategory = '/addCategory';
  static const String categoryDetail = '/categoryDetail';
  static const String register = '/register';
  static const String registerOTP = '/registerOTP';
  static const String registerPersonalInfo = '/registerPersonalInfo';
  static const String registerBranchOption = '/registerBranchOption';
  static const String registerStoreInfo = '/registerStoreInfo';
  static const String registerComplete = '/registerComplete';
  static const String login = '/login';
  static const String createTransaction = '/createTransaction';
}

class CustomKeys {
  static const String accessToken = 'accessToken';
}

class CustomTickerDurations {
  static const int resendOTPDuration = 30;
}

enum Process {
  neutral,
  processing,
  processed,
  valid,
  invalid,
  error,
}

enum Sex {
  male,
  female,
}

//sex dropdown form field
const Map<Sex, String> sexFormFieldItems = {
  Sex.male: 'Nam',
  Sex.female: 'Nữ',
};

//isBranch options
const Map<bool, String> isBranchRadioOptions = {
  false: 'Không',
  true: 'Có',
};

class CustomVar {
  static final unnamedScrapCategory = ScrapCategoryModel(
    id: '00000000-0000-0000-0000-000000000000',
    appliedAmount: null,
    name: 'Chưa phân loại',
    bonusAmount: null,
  );
}
