import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final isLoading = true.obs;
  final banners = <String>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final newArrivals = <ProductModel>[].obs;
  final popularCategories = <CategoryModel>[].obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // Simulate API requests - in production, these would be real API calls
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load mock data
      _loadMockData();
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load home data. Please try again.';
      print('Error fetching home data: $e');
    }
  }

  Future<void> refreshHomeData() async {
    return fetchHomeData();
  }

  // Mock data for development
  void _loadMockData() {
    // Mock banners
    banners.value = [
      'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'https://images.unsplash.com/photo-1607083206968-13611e3d76db?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    ];
    
    // Mock categories
    popularCategories.value = [
      CategoryModel(
        id: '1',
        name: 'Electronics',
        description: 'Electronic devices and gadgets',
        image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1901&q=80',
        isActive: true,
        level: 1,
        slug: 'electronics',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        id: '2',
        name: 'Fashion',
        description: 'Clothing and accessories',
        image: 'https://images.unsplash.com/photo-1445205170230-053b83016050?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
        isActive: true,
        level: 1,
        slug: 'fashion',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        id: '3',
        name: 'Home & Kitchen',
        description: 'Home decor and kitchen essentials',
        image: 'https://images.unsplash.com/photo-1556911220-bff31c812dba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1568&q=80',
        isActive: true,
        level: 1,
        slug: 'home-kitchen',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        id: '4',
        name: 'Beauty',
        description: 'Beauty and personal care products',
        image: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
        isActive: true,
        level: 1,
        slug: 'beauty',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        id: '5',
        name: 'Sports',
        description: 'Sports equipment and activewear',
        image: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        isActive: true,
        level: 1,
        slug: 'sports',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    // Mock featured products
    featuredProducts.value = [
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
        categoryId: '1',
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
        categoryId: '1',
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
        name: 'Designer Leather Handbag',
        description: 'Elegant design with spacious compartments',
        price: 89.99,
        compareAtPrice: 119.99,
        images: [
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        quantity: 25,
        categoryId: '2',
        sellerId: 'seller3',
        sellerName: 'Fashion Trends',
        rating: 4.7,
        reviewCount: 65,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'LuxeStyle',
      ),
    ];
    
    // Mock new arrivals
    newArrivals.value = [
      ProductModel(
        id: '4',
        name: 'Smart Home Speaker',
        description: 'Voice-controlled speaker with premium sound',
        price: 79.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1589003077984-894e133dabab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80',
        ],
        quantity: 40,
        categoryId: '1',
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.4,
        reviewCount: 28,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'SmartHome',
      ),
      ProductModel(
        id: '5',
        name: 'Ultra Slim Laptop',
        description: 'Powerful performance in a thin design',
        price: 899.99,
        compareAtPrice: 999.99,
        images: [
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
        ],
        quantity: 15,
        categoryId: '1',
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
        id: '6',
        name: 'Stainless Steel Kitchen Set',
        description: 'Premium quality cookware set',
        price: 149.99,
        compareAtPrice: 199.99,
        images: [
          'https://images.unsplash.com/photo-1541014741259-de529411b96a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
        ],
        quantity: 20,
        categoryId: '3',
        sellerId: 'seller4',
        sellerName: 'Home Essentials',
        rating: 4.6,
        reviewCount: 45,
        isFeatured: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        brand: 'KitchenElite',
      ),
    ];
  }
}