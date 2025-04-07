import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/storage_constants.dart';
import '../data/models/user_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/wishlist_item_model.dart';
import '../data/models/address_model.dart';
import '../data/models/product_model.dart';
import '../data/models/category_model.dart';
import '../data/models/order_model.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(CartItemModelAdapter());
    Hive.registerAdapter(WishlistItemModelAdapter());
    Hive.registerAdapter(AddressModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(OrderModelAdapter());

    // Open Hive boxes
    await Hive.openBox<UserModel>(StorageConstants.userBox);
    await Hive.openBox<CartItemModel>(StorageConstants.cartBox);
    await Hive.openBox<WishlistItemModel>(StorageConstants.wishlistBox);
    await Hive.openBox<AddressModel>(StorageConstants.addressBox);
    await Hive.openBox<ProductModel>(StorageConstants.productBox);
    await Hive.openBox<CategoryModel>(StorageConstants.categoryBox);
    await Hive.openBox<OrderModel>(StorageConstants.orderBox);
    await Hive.openBox(StorageConstants.settingsBox);

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(StorageConstants.token, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(StorageConstants.token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.setString(StorageConstants.refreshToken, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(StorageConstants.refreshToken);
  }

  Future<void> saveUserId(String userId) async {
    await _prefs.setString(StorageConstants.userId, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(StorageConstants.userId);
  }

  Future<void> clearSession() async {
    await _prefs.remove(StorageConstants.token);
    await _prefs.remove(StorageConstants.refreshToken);
    await _prefs.remove(StorageConstants.userId);

    // Clear user-related boxes
    await Hive.box<UserModel>(StorageConstants.userBox).clear();
    await Hive.box<CartItemModel>(StorageConstants.cartBox).clear();
    await Hive.box<WishlistItemModel>(StorageConstants.wishlistBox).clear();
    await Hive.box<AddressModel>(StorageConstants.addressBox).clear();
    await Hive.box<OrderModel>(StorageConstants.orderBox).clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // User management
  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(StorageConstants.userBox);
    await box.put('current_user', user);
    await saveUserId(user.id);
  }

  Future<UserModel?> getUser() async {
    final box = Hive.box<UserModel>(StorageConstants.userBox);
    return box.get('current_user');
  }

  // Cart management
  Future<void> saveCartItem(CartItemModel item) async {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);
    await box.put(item.productId, item);
  }

  Future<void> updateCartItem(CartItemModel item) async {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);
    await box.put(item.productId, item);
  }

  Future<void> addToCart(CartItemModel item) async {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);

    // Check if the product is already in the cart with the same color/size
    final existingItem = box.values.firstWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.color == item.color &&
          cartItem.size == item.size,
      orElse:
          () =>
              CartItemModel(productId: '', product: item.product, quantity: 0),
    );

    if (existingItem.productId.isNotEmpty) {
      // Update quantity if item already exists
      final updatedItem = CartItemModel(
        productId: existingItem.productId,
        product: existingItem.product,
        quantity: existingItem.quantity + item.quantity,
        color: existingItem.color,
        size: existingItem.size,
      );
      await box.put(existingItem.productId, updatedItem);
    } else {
      // Add new item
      await box.put(item.productId, item);
    }
  }

  Future<void> removeFromCart(String productId) async {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);
    await box.delete(productId);
  }

  Future<void> clearCart() async {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);
    await box.clear();
  }

  List<CartItemModel> getCartItems() {
    final box = Hive.box<CartItemModel>(StorageConstants.cartBox);
    return box.values.toList();
  }

  // Wishlist management
  Future<void> addToWishlist(ProductModel product) async {
    final box = Hive.box<ProductModel>(StorageConstants.wishlistBox);
    await box.put(product.id, product);
  }

  Future<void> removeFromWishlist(String productId) async {
    final box = Hive.box<ProductModel>(StorageConstants.wishlistBox);
    await box.delete(productId);
  }

  List<ProductModel> getWishlistItems() {
    final box = Hive.box<ProductModel>(StorageConstants.wishlistBox);
    return box.values.toList();
  }

  bool isInWishlist(String productId) {
    final box = Hive.box<ProductModel>(StorageConstants.wishlistBox);
    return box.containsKey(productId);
  }

  // Product caching
  Future<void> cacheProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(StorageConstants.productBox);
    await box.put(product.id, product);
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = Hive.box<ProductModel>(StorageConstants.productBox);
    final Map<String, ProductModel> productsMap = {
      for (var product in products) product.id: product,
    };
    await box.putAll(productsMap);
  }

  ProductModel? getCachedProduct(String productId) {
    final box = Hive.box<ProductModel>(StorageConstants.productBox);
    return box.get(productId);
  }

  List<ProductModel> getCachedProducts() {
    final box = Hive.box<ProductModel>(StorageConstants.productBox);
    return box.values.toList();
  }

  // Category caching
  Future<void> cacheCategory(CategoryModel category) async {
    final box = Hive.box<CategoryModel>(StorageConstants.categoryBox);
    await box.put(category.id, category);
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final box = Hive.box<CategoryModel>(StorageConstants.categoryBox);
    final Map<String, CategoryModel> categoriesMap = {
      for (var category in categories) category.id: category,
    };
    await box.putAll(categoriesMap);
  }

  List<CategoryModel> getCachedCategories() {
    final box = Hive.box<CategoryModel>(StorageConstants.categoryBox);
    return box.values.toList();
  }

  // Address management
  Future<void> saveAddress(AddressModel address) async {
    final box = Hive.box<AddressModel>(StorageConstants.addressBox);
    await box.put(address.id, address);
  }

  Future<void> removeAddress(String addressId) async {
    final box = Hive.box<AddressModel>(StorageConstants.addressBox);
    await box.delete(addressId);
  }

  List<AddressModel> getAddresses() {
    final box = Hive.box<AddressModel>(StorageConstants.addressBox);
    return box.values.toList();
  }

  AddressModel? getDefaultAddress() {
    final box = Hive.box<AddressModel>(StorageConstants.addressBox);
    final addresses = box.values.toList();
    if (addresses.isEmpty) return null;

    return addresses.firstWhereOrNull((address) => address.isDefault) ??
        addresses.first;
  }

  // Order management
  Future<void> saveOrder(OrderModel order) async {
    final box = Hive.box<OrderModel>(StorageConstants.orderBox);
    await box.put(order.id, order);
  }

  List<OrderModel> getOrders() {
    final box = Hive.box<OrderModel>(StorageConstants.orderBox);
    return box.values.toList();
  }

  // Last sync time
  Future<void> setLastSyncTime(DateTime time) async {
    await _prefs.setString(
      StorageConstants.lastSyncTime,
      time.toIso8601String(),
    );
  }

  DateTime? getLastSyncTime() {
    final timeStr = _prefs.getString(StorageConstants.lastSyncTime);
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  // First launch check
  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(StorageConstants.isFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    await _prefs.setBool(StorageConstants.isFirstLaunch, isFirst);
  }

  // Theme and preferences
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(StorageConstants.isDarkMode, isDark);
  }

  bool getDarkMode() {
    return _prefs.getBool(StorageConstants.isDarkMode) ?? false;
  }

  // Currency preference
  Future<void> setCurrency(String currency) async {
    await _prefs.setString(StorageConstants.currency, currency);
  }

  String getCurrency() {
    return _prefs.getString(StorageConstants.currency) ?? 'USD';
  }

  // General settings functions
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<void> clearToken() async {
    await _prefs.remove(StorageConstants.token);
    await _prefs.remove(StorageConstants.refreshToken);
  }

  Future<void> clearUserData() async {
    await clearSession();

    // Clear additional user-specific settings
    final box = Hive.box(StorageConstants.settingsBox);
    await box.clear();

    // Remove user-specific shared preferences
    await _prefs.remove('push_notifications');
    await _prefs.remove('email_notifications');
    await _prefs.remove('biometric_auth');
  }
}
