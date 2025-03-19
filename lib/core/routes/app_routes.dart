class AppRoutes {
  /// The Initial Page
  static const introLogin = '/intro_login'; //ERP
  static const onboarding = '/onboarding'; //ERP

  /* <---- Login, Signup -----> */
  static const signup = '/signup'; //ERP
  static const numberVerification = '/numberVerification'; //ERP

  static const login = '/login';
  static const loginOrSignup = '/loginOrSignup';
  static const forgotPassword = '/forgotPassword';
  static const passwordReset = '/passwordReset';

  /* <---- ENTRYPOINT -----> */
  static const entryPoint = '/entry_point'; // ERP

  /* <---- Products Order Process -----> */
  static const home = '/home';
  static const newItems = '/newItems';
  static const popularItems = '/popularItems';
  static const bundleProduct = '/bundleProduct';
  static const createMyPack = '/createMyPack';
  static const bundleDetailsPage = '/bundleDetailsPage';
  static const productDetails = '/productDetails';
  static const cartPage = '/cartPage';
  static const savePage = '/favouriteList';
  static const checkoutPage = '/checkoutPage';

  /// Order Status
  static const orderSuccessfull = '/orderSuccessfull';
  static const orderFailed = '/orderFailed';
  static const noOrderYet = '/noOrderYet';

  /// Category
  static const category = '/category';
  static const categoryDetails = '/categoryDetails';

  /// Search Page
  static const search = '/search';
  static const searchResult = '/searchResult';

  /* <---- Profile & Settings -----> */
  static const profile = 'profile';
  static const myOrder = '/myOrder';
  static const orderDetails = '/orderDetails';
  static const coupon = '/coupon';
  static const couponDetails = '/couponDetails';
  static const deliveryAddress = '/deliveryAddress';
  static const newAddress = '/newAddress';
  static const orderTracking = '/orderTracking';
  static const profileEdit = '/profileEdit';
  static const notifications = '/notifications';
  static const settings = '/settings';
  static const settingsLanguage = '/settingsLanguage';
  static const settingsNotifications = '/settingsNotifications';
  static const changePassword = '/changePassword';
  static const changePhoneNumber = '/changePhoneNumber';

  /* <---- Review and Comments -----> */
  static const review = '/review';
  static const submitReview = '/submitReview';
  // Not Needed
  // static const errorPage = '/errorPage';

  /* <---- Drawer Page -----> */
  static const drawerPage = '/drawerPage';
  static const aboutUs = '/aboutUs';
  static const faq = '/faq';
  static const termsAndConditions = '/termsAndConditions';
  static const help = '/help';
  static const contactUs = '/contactUs';

  /* <---- Payment Method -----> */
  static const paymentMethod = '/paymentMethod';
  static const paymentCardAdd = '/paymentCardAdd';

  /* <---- Labour Method -----> */
  static const labourGridPage = "/labourGridPage";
  static const newlabour = '/newlabour';

  /* <---- Purchase Requisition -----> */
  static const prGridPage = "/prGridPage";
  static const newPR = "/newPR";

  /* <---- Purchase Requisition -----> */
  static const selfAttendance = "/selfAttendance";

  /* <---- User Profile -----> */
  static const myProfile = "/myProfile";
  static const salarySlip = "/salarySlip";
  static const assignItems = "/assignItems";

  /* <---- DPR Dashboard -----> */
  static const erpDprEntry = "/erpDprEntry";
}
