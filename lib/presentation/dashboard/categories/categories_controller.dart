import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../services/api_service.dart';

class CategoriesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final categories = <CategoryModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // Simulate API request - in production, this would be a real API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load mock data
      _loadMockCategories();
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load categories. Please try again.';
      print('Error fetching categories: $e');
    }
  }
  
  Future<void> refreshCategories() async {
    return fetchCategories();
  }
  
  // Mock data for development
  void _loadMockCategories() {
    categories.value = [
      CategoryModel(
        id: '1',
        name: 'Electronics',
        description: 'Electronic devices and gadgets',
        image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1901&q=80',
        isActive: true,
        level: 1,
        slug: 'electronics',
        subcategories: [
          CategoryModel(
            id: '1-1',
            name: 'Smartphones',
            description: 'Mobile phones and accessories',
            image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
            isActive: true,
            parentId: '1',
            level: 2,
            slug: 'smartphones',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            id: '1-2',
            name: 'Laptops',
            description: 'Notebooks and accessories',
            image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
            isActive: true,
            parentId: '1',
            level: 2,
            slug: 'laptops',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            id: '1-3',
            name: 'Audio',
            description: 'Headphones, speakers and audio equipment',
            image: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1465&q=80',
            isActive: true,
            parentId: '1',
            level: 2,
            slug: 'audio',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
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
        subcategories: [
          CategoryModel(
            id: '2-1',
            name: 'Men',
            description: 'Men\'s clothing and accessories',
            image: 'https://images.unsplash.com/photo-1516826957135-700dedea698c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
            isActive: true,
            parentId: '2',
            level: 2,
            slug: 'men',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            id: '2-2',
            name: 'Women',
            description: 'Women\'s clothing and accessories',
            image: 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            isActive: true,
            parentId: '2',
            level: 2,
            slug: 'women',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            id: '2-3',
            name: 'Kids',
            description: 'Children\'s clothing and accessories',
            image: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            isActive: true,
            parentId: '2',
            level: 2,
            slug: 'kids',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
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
        subcategories: [
          CategoryModel(
            id: '3-1',
            name: 'Kitchen',
            description: 'Kitchen appliances and utensils',
            image: 'https://images.unsplash.com/photo-1556910633-5099dc3971e6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            isActive: true,
            parentId: '3',
            level: 2,
            slug: 'kitchen',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            id: '3-2',
            name: 'Furniture',
            description: 'Home furniture and decor',
            image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            isActive: true,
            parentId: '3',
            level: 2,
            slug: 'furniture',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
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
  }
}