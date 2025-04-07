import 'package:get/get.dart';
import '../presentation/dashboard/home/home_screen.dart';
import '../presentation/dashboard/profile/profile_screen.dart';
import 'app_routes.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/splash/splash_binding.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/onboarding/onboarding_binding.dart';
import '../presentation/auth/login/login_screen.dart';
import '../presentation/auth/login/login_binding.dart';
import '../presentation/auth/register/register_screen.dart';
import '../presentation/auth/register/register_binding.dart';
import '../presentation/auth/forgot_password/forgot_password_screen.dart';
import '../presentation/auth/forgot_password/forgot_password_binding.dart';
import '../presentation/auth/auth_binding.dart';
import '../presentation/dashboard/dashboard_screen.dart';
import '../presentation/dashboard/dashboard_binding.dart';
import '../presentation/dashboard/home/home_binding.dart';
import '../presentation/product/product_detail_screen.dart';
import '../presentation/product/product_detail_binding.dart';
import '../presentation/category/category_detail_screen.dart';
import '../presentation/category/category_detail_binding.dart';
import '../presentation/search/search_screen.dart';
import '../presentation/search/search_binding.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/notifications/notifications_binding.dart';
import '../presentation/profile/profile_binding.dart';
import '../presentation/wishlist/wishlist_screen.dart';
import '../presentation/wishlist/wishlist_binding.dart';
import '../presentation/orders/orders_screen.dart';
import '../presentation/orders/orders_binding.dart';
import '../presentation/orders/order_detail/order_detail_screen.dart';
import '../presentation/orders/order_detail/order_detail_binding.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/settings/settings_binding.dart';
import '../presentation/settings/account/edit_profile_screen.dart';
import '../presentation/settings/account/edit_profile_binding.dart';
import '../presentation/address/address_list_screen.dart';
import '../presentation/address/address_list_binding.dart';
import '../presentation/address/address_form_screen.dart';
import '../presentation/address/address_form_binding.dart';
import '../presentation/checkout/checkout_screen.dart';
import '../presentation/checkout/checkout_binding.dart';
import '../presentation/checkout/order_confirmation/order_confirmation_screen.dart';
import '../presentation/checkout/order_confirmation/order_confirmation_binding.dart';
import '../presentation/payment/payment_method_screen.dart';
import '../presentation/payment/payment_method_binding.dart';
import '../presentation/payment/payment_form_screen.dart';
import '../presentation/payment/payment_form_binding.dart';
import '../presentation/reviews/write_review_screen.dart';
import '../presentation/reviews/write_review_binding.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      bindings: [HomeBinding()],
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductDetailBinding(),
    ),

    GetPage(
      name: AppRoutes.categoryDetail,
      page: () => const CategoryDetailScreen(),
      binding: CategoryDetailBinding(),
    ),

    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistScreen(),
      binding: WishlistBinding(),
    ),

    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
      binding: OrdersBinding(),
    ),

    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailScreen(),
      binding: OrderDetailBinding(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.shippingAddresses,
      page: () => const AddressListScreen(),
      binding: AddressListBinding(),
    ),

    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddressFormScreen(isEditing: false),
      binding: AddressFormBinding(),
    ),

    GetPage(
      name: AppRoutes.editAddress,
      page: () => const AddressFormScreen(isEditing: true),
      binding: AddressFormBinding(),
    ),

    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
    ),

    GetPage(
      name: AppRoutes.orderConfirmation,
      page: () => const OrderConfirmationScreen(),
      binding: OrderConfirmationBinding(),
    ),

    GetPage(
      name: AppRoutes.paymentMethods,
      page: () => const PaymentMethodScreen(),
      binding: PaymentMethodBinding(),
    ),

    GetPage(
      name: AppRoutes.addPaymentMethod,
      page: () => const PaymentFormScreen(isEditing: false),
      binding: PaymentFormBinding(),
    ),

    GetPage(
      name: AppRoutes.editPaymentMethod,
      page: () => const PaymentFormScreen(isEditing: true),
      binding: PaymentFormBinding(),
    ),

    GetPage(
      name: AppRoutes.writeReview,
      page: () => const WriteReviewScreen(),
      binding: WriteReviewBinding(),
    ),

    // Additional routes will be added here as we build them
    // etc.
  ];
}
