import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../services/api_service.dart';

class CategoryDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final category = Rxn<CategoryModel>();
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final sortOption = 'newest'.obs;
  final activeFilters = <String, dynamic>{}.obs;
  
  // Pagination
  final page = 1.obs;
  final totalPages = 1.obs;
  final isLoadingMore = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get category from arguments
    if (Get.arguments is CategoryModel) {
      category.value = Get.arguments as CategoryModel;
      fetchCategoryProducts();
    } else if (Get.arguments is String) {
      // If only category ID is provided
      fetchCategoryById(Get.arguments as String);
    } else {
      hasError.value = true;
      errorMessage.value = 'Category not found';
    }
  }
  
  Future<void> fetchCategoryById(String categoryId) async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // In a real app, this would fetch from API
      // Simulating API call for now
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock a category retrieval
      category.value = CategoryModel(
        id: categoryId,
        name: 'Sample Category',
        description: 'This is a sample category fetched by ID',
        isActive: true,
        level: 1,
        slug: 'sample-category',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await fetchCategoryProducts();
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to fetch category';
      print('Error fetching category: $e');
    }
  }
  
  Future<void> fetchCategoryProducts() async {
    if (category.value == null) return;
    
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // Simulate API request - in production, this would be a real API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load mock data
      _loadMockProducts();
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load products. Please try again.';
      print('Error fetching category products: $e');
    }
  }
  
  Future<void> loadMoreProducts() async {
    if (page.value >= totalPages.value || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    
    try {
      // Simulate API request
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load more mock products
      final moreProducts = _getMoreMockProducts();
      products.addAll(moreProducts);
      
      page.value++;
      isLoadingMore.value = false;
    } catch (e) {
      isLoadingMore.value = false;
      print('Error loading more products: $e');
    }
  }
  
  Future<void> refreshProducts() async {
    page.value = 1;
    return fetchCategoryProducts();
  }
  
  void setSortOption(String option) {
    if (sortOption.value == option) return;
    
    sortOption.value = option;
    _sortProducts();
  }
  
  void _sortProducts() {
    switch (sortOption.value) {
      case 'newest':
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price-low-high':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-high-low':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popularity':
        products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    
    // Trigger UI update
    products.refresh();
  }
  
  void toggleFilter(String key, dynamic value) {
    if (activeFilters.containsKey(key) && activeFilters[key] == value) {
      activeFilters.remove(key);
    } else {
      activeFilters[key] = value;
    }
    
    // Refresh products with filters
    refreshProducts();
  }
  
  void resetFilters() {
    activeFilters.clear();
    refreshProducts();
  }
  
  // Mock data for development
  void _loadMockProducts() {
    products.value = [
      ProductModel(
        id: '1',
        name: 'Wireless Bluetooth Headphones',
        description: 'Premium sound quality with noise cancellation',
        price: 129.99,
        compareAtPrice: 179.99,
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        quantity: 50,
        categoryId: category.value!.id,
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.8,
        reviewCount: 142,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'SoundMaster',
      ),
      ProductModel(
        id: '2',
        name: 'Smart Watch Series 5',
        description: 'Track your fitness and stay connected',
        price: 199.99,
        compareAtPrice: 249.99,
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1399&q=80',
        ],
        quantity: 30,
        categoryId: category.value!.id,
        sellerId: 'seller2',
        sellerName: 'GadgetHub',
        rating: 4.5,
        reviewCount: 78,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'TechFit',
      ),
      ProductModel(
        id: '3',
        name: 'Ultra Slim Laptop',
        description: 'Powerful performance in a thin design',
        price: 899.99,
        compareAtPrice: 999.99,
        images: [
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
        ],
        quantity: 15,
        categoryId: category.value!.id,
        sellerId: 'seller2',
        sellerName: 'GadgetHub',
        rating: 4.9,
        reviewCount: 32,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'TechPro',
      ),
      ProductModel(
        id: '4',
        name: 'Wireless Earbuds',
        description: 'Crystal clear sound with long battery life',
        price: 89.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1378&q=80',
        ],
        quantity: 25,
        categoryId: category.value!.id,
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.3,
        reviewCount: 56,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'SoundMaster',
      ),
      ProductModel(
        id: '5',
        name: 'Bluetooth Speaker',
        description: 'Portable speaker with deep bass',
        price: 59.99,
        compareAtPrice: 79.99,
        images: [
          'https://images.unsplash.com/photo-1589003077984-894e133dabab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80',
        ],
        quantity: 40,
        categoryId: category.value!.id,
        sellerId: 'seller3',
        sellerName: 'Audio Experts',
        rating: 4.6,
        reviewCount: 89,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'SonicSound',
      ),
      ProductModel(
        id: '6',
        name: 'Digital Camera',
        description: 'Capture memories with professional quality',
        price: 399.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1364&q=80',
        ],
        quantity: 10,
        categoryId: category.value!.id,
        sellerId: 'seller2',
        sellerName: 'GadgetHub',
        rating: 4.7,
        reviewCount: 41,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'PhotoPro',
      ),
    ];
    
    // Sort products based on current sort option
    _sortProducts();
    
    // Set total pages for pagination
    totalPages.value = 3; // Mock value
  }
  
  List<ProductModel> _getMoreMockProducts() {
    // Return different mock products for page 2
    return [
      ProductModel(
        id: '7',
        name: 'Gaming Mouse',
        description: 'Precision control for competitive gaming',
        price: 49.99,
        compareAtPrice: 69.99,
        images: [
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1467&q=80',
        ],
        quantity: 35,
        categoryId: category.value!.id,
        sellerId: 'seller4',
        sellerName: 'Game Station',
        rating: 4.4,
        reviewCount: 67,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'GamePro',
      ),
      ProductModel(
        id: '8',
        name: 'Mechanical Keyboard',
        description: 'Tactile feedback with customizable RGB lighting',
        price: 79.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1595225476474-63038da0e381?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
        ],
        quantity: 20,
        categoryId: category.value!.id,
        sellerId: 'seller4',
        sellerName: 'Game Station',
        rating: 4.8,
        reviewCount: 52,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'MechType',
      ),
      ProductModel(
        id: '9',
        name: 'External SSD',
        description: 'Fast storage with compact design',
        price: 129.99,
        compareAtPrice: 159.99,
        images: [
          'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
        ],
        quantity: 15,
        categoryId: category.value!.id,
        sellerId: 'seller2',
        sellerName: 'GadgetHub',
        rating: 4.6,
        reviewCount: 38,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'DataStore',
      ),
    ];
  }
}