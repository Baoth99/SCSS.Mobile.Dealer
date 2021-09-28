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
  //login_view
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String loginButton = 'Đăng nhập';
  static const String invalidPassword =
      'Mật khẩu cần chứa ít nhất 1 ký tự in hoa, 1 ký tự đặc biệt';
  static const String invalidPhone = 'Số điện thoại không hợp lệ';
  static const String blankPassword = 'Nhập mật khẩu';
  static const String blankPhone = 'Nhập số điện thoại';
  static const String passwordLabel = 'Mật khẩu';
  static const String phoneLabel = 'Số điện thoại';
  static const String wrongPasswordOrPhone =
      'Số điện thoại hoặc mật khẩu không chính xác';
  static const String forgetPassword = 'Bạn quên mật khẩu?';
  static const String forgetPasswordTextButton = 'Lấy lại mật khẩu';
  static const String register = 'Bạn chưa có tài khoản?';
  static const String registerTextButton = 'Đăng ký';
  //api
  static const String apiUrlTokenLink = 'connect/token';
  static const String apiUrlUserInfoLink = 'connect/userinfo';
  static const String loginFailedException = 'Login failed';
  static const String fetchTokenFailedException = 'Failed to fetch token';
  static const String fetchUserInfoFailedException =
      'Failed to fetch user info';
  //register
  static const String registerWelcomeText =
      'Xin chào, số điện thoại của bạn là?';

  static const String next = 'Tiếp';
  static const String otpMessage =
      'Một mã số gồm 6 chữ số vừa được gửi đến số điện thoại';
  static const String otpErrorMessage =
      'Gửi mã số thất bại, xin đợi 5 phút và thử lại';
  static const String invalidOTP = 'Mã số không hợp lệ';
  static const String checkOTPErrorMessage =
      'Đã có lỗi xảy ra, xin đợi 5 phút và thử lại';
}

class CustomFormats {
  static const String birthday = 'dd/MM/yyyy';
}

class CustomRegexs {
  static const String phoneRegex = r'^0[0-9]{9}$';
  static const String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*\\()\-_+=[\].,;:{}|~`<>]).{8,64}$';
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
  static const String registerPersonalDetail = '/registerPersonalDetail';
  static const String registerStoreBranchOption = '/registerStoreBranchOption';
  static const String registerStoreDetail = '/registerStoreDetail';
  static const String registerComplete = '/registerComplete';
}

enum Process {
  neutral,
  processing,
  processed,
  valid,
  invalid,
  error,
}
