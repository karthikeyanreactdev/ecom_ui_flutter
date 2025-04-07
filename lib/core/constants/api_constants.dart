class ApiConstants {
  // Base URLs
  static const String baseUrl = "http://localhost:5000/api";
  static const String productionUrl =
      "https://multivendor-ecommerce-api.example.com/api";

  // Authentication endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String refreshToken = "/auth/refresh-token";
  static const String verifyEmail = "/auth/verify-email";

  // User endpoints
  static const String userProfile = "/user/profile";
  static const String updateProfile = "/user/profile";
  static const String addresses = "/user/addresses";
  static const String address = "/user/addresses/{id}";

  // Product endpoints
  static const String products = "/products";
  static const String product = "/products/{id}";
  static const String productsByCategory = "/products/category/{id}";
  static const String searchProducts = "/products/search";
  static const String featuredProducts = "/products/featured";
  static const String newArrivals = "/products/new-arrivals";
  static const String topRated = "/products/top-rated";

  // Category endpoints
  static const String categories = "/categories";
  static const String category = "/categories/{id}";

  // Cart endpoints
  static const String cart = "/cart";
  static const String addToCart = "/cart/items";
  static const String updateCartItem = "/cart/items/{id}";
  static const String removeCartItem = "/cart/items/{id}";

  // Wishlist endpoints
  static const String wishlist = "/wishlist";
  static const String addToWishlist = "/wishlist/items";
  static const String removeFromWishlist = "/wishlist/items/{id}";

  // Order endpoints
  static const String orders = "/orders";
  static const String order = "/orders/{id}";
  static const String cancelOrder = "/orders/{id}/cancel";
  static const String returnOrder = "/orders/{id}/return";

  // Review endpoints
  static const String addReview = "/reviews";
  static const String productReviews = "/products/{id}/reviews";

  // Payment endpoints
  static const String checkoutOptions = "/checkout/options";
  static const String initiatePayment = "/payments/initiate";
  static const String verifyPayment = "/payments/verify";

  // Coupon endpoints
  static const String validateCoupon = "/coupons/validate";
  static const String applyCoupon = "/cart/apply-coupon";

  // Misc
  static const String banners = "/banners";
}
