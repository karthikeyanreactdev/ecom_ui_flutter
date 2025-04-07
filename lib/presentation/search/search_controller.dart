import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class SearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  // Text field controller
  final textController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final searchResults = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final searchHistory = <String>[].obs;
  final suggestedProducts = <ProductModel>[].obs;
  final suggestedCategories = <String>[].obs;
  final hasError = false.obs;
  
  // Pagination
  final page = 1.obs;
  final totalPages = 1.obs;
  final isLoadingMore = false.obs;
  
  // Filters
  final activeFilters = <String, dynamic>{}.obs;
  final sortOption = 'relevance'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
    loadSuggestedContent();
    
    // Listen to text changes for real-time suggestions
    textController.addListener(_onSearchTextChanged);
  }
  
  @override
  void onClose() {
    textController.removeListener(_onSearchTextChanged);
    textController.dispose();
    super.onClose();
  }
  
  void _onSearchTextChanged() {
    if (textController.text.isNotEmpty) {
      // Get real-time suggestions as user types
      getSuggestions(textController.text);
    } else {
      // Clear suggestions when search field is empty
      recentSearches.clear();
    }
  }
  
  Future<void> loadRecentSearches() async {
    try {
      // In a real app, these would come from the StorageService
      // This is a placeholder for now
      searchHistory.value = [
        'headphones',
        'smartphone',
        'laptop',
        'watch',
        'camera',
      ];
    } catch (e) {
      print('Error loading recent searches: $e');
    }
  }
  
  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) return;
    
    try {
      // Filter search history by the query
      recentSearches.value = searchHistory
          .where((term) => term.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      // In a real app, you would fetch suggestions from the API
      // Mocking it for now
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock suggested categories based on query
      suggestedCategories.value = _getMockSuggestedCategories(query);
    } catch (e) {
      print('Error getting suggestions: $e');
    }
  }
  
  List<String> _getMockSuggestedCategories(String query) {
    final allCategories = [
      'Electronics', 'Smartphones', 'Laptops', 'Headphones',
      'Clothing', 'Men\'s Fashion', 'Women\'s Fashion',
      'Home & Kitchen', 'Furniture', 'Appliances',
      'Beauty', 'Personal Care', 
      'Sports', 'Fitness Equipment'
    ];
    
    return allCategories
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .take(3)
        .toList();
  }
  
  Future<void> loadSuggestedContent() async {
    try {
      // In a real app, these would come from the API based on user's history
      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 800));
      
      final now = DateTime.now();
      
      suggestedProducts.value = [
        ProductModel(
          id: '1',
          name: 'Wireless Noise-Cancelling Headphones',
          description: 'Premium sound quality with active noise cancellation',
          price: 149.99,
          compareAtPrice: 199.99,
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
          ],
          quantity: 50,
          categoryId: '1',
          sellerId: 'seller1',
          sellerName: 'Tech World',
          rating: 4.7,
          reviewCount: 128,
          isFeatured: true,
          isNewArrival: false,
          createdAt: now,
          updatedAt: now,
          brand: 'AudioPro',
        ),
        ProductModel(
          id: '2',
          name: 'Smart Fitness Watch',
          description: 'Track your workouts and monitor your health',
          price: 89.99,
          compareAtPrice: 119.99,
          images: [
            'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1472&q=80',
          ],
          quantity: 35,
          categoryId: '1',
          sellerId: 'seller2',
          sellerName: 'Fitness Tech',
          rating: 4.5,
          reviewCount: 92,
          isFeatured: true,
          isNewArrival: true,
          createdAt: now,
          updatedAt: now,
          brand: 'FitTech',
        ),
      ];
    } catch (e) {
      print('Error loading suggested content: $e');
    }
  }
  
  Future<void> search(String query) async {
    if (query.isEmpty) return;
    
    isLoading.value = true;
    hasError.value = false;
    page.value = 1;
    
    try {
      // Save search query to history
      _addToSearchHistory(query);
      
      // Clear previous results
      searchResults.clear();
      
      // In a real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock search results
      searchResults.value = _getMockSearchResults(query);
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      print('Error searching: $e');
    }
  }
  
  void _addToSearchHistory(String query) {
    // Remove if already exists
    searchHistory.remove(query);
    
    // Add to beginning of the list
    searchHistory.insert(0, query);
    
    // Keep only most recent 10 searches
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    
    // In a real app, this would be saved to storage
    // _storageService.saveSearchHistory(searchHistory);
  }
  
  List<ProductModel> _getMockSearchResults(String query) {
    final now = DateTime.now();
    final mockProducts = [
      ProductModel(
        id: '1',
        name: 'Wireless Noise-Cancelling Headphones',
        description: 'Premium sound quality with active noise cancellation',
        price: 149.99,
        compareAtPrice: 199.99,
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        quantity: 50,
        categoryId: '1',
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.7,
        reviewCount: 128,
        isFeatured: true,
        isNewArrival: false,
        createdAt: now,
        updatedAt: now,
        brand: 'AudioPro',
      ),
      ProductModel(
        id: '2',
        name: 'Smart Fitness Watch',
        description: 'Track your workouts and monitor your health',
        price: 89.99,
        compareAtPrice: 119.99,
        images: [
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1472&q=80',
        ],
        quantity: 35,
        categoryId: '1',
        sellerId: 'seller2',
        sellerName: 'Fitness Tech',
        rating: 4.5,
        reviewCount: 92,
        isFeatured: true,
        isNewArrival: true,
        createdAt: now,
        updatedAt: now,
        brand: 'FitTech',
      ),
      ProductModel(
        id: '3',
        name: 'Smartphone Pro Max',
        description: 'Latest model with advanced camera system',
        price: 999.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1527&q=80',
        ],
        quantity: 20,
        categoryId: '1',
        sellerId: 'seller3',
        sellerName: 'Mobile Solutions',
        rating: 4.9,
        reviewCount: 215,
        isFeatured: true,
        isNewArrival: true,
        createdAt: now,
        updatedAt: now,
        brand: 'TechX',
      ),
      ProductModel(
        id: '4',
        name: 'Wireless Earbuds',
        description: 'Compact and powerful with long battery life',
        price: 79.99,
        compareAtPrice: 99.99,
        images: [
          'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        quantity: 45,
        categoryId: '1',
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.6,
        reviewCount: 78,
        isFeatured: false,
        isNewArrival: true,
        createdAt: now,
        updatedAt: now,
        brand: 'AudioPro',
      ),
      ProductModel(
        id: '5',
        name: 'Laptop Pro 15-inch',
        description: 'Powerful laptop for professionals',
        price: 1299.99,
        compareAtPrice: 1499.99,
        images: [
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
        ],
        quantity: 12,
        categoryId: '1',
        sellerId: 'seller3',
        sellerName: 'Computer Hub',
        rating: 4.8,
        reviewCount: 103,
        isFeatured: true,
        isNewArrival: false,
        createdAt: now,
        updatedAt: now,
        brand: 'TechPro',
      ),
    ];
    
    // Filter by query
    return mockProducts
        .where((product) => 
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.brand!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  Future<void> loadMoreResults() async {
    if (page.value >= totalPages.value || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    
    try {
      // In a real app, this would be an API call with the next page
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock additional results
      final moreResults = _getMockMoreResults();
      searchResults.addAll(moreResults);
      
      page.value++;
      isLoadingMore.value = false;
    } catch (e) {
      isLoadingMore.value = false;
      print('Error loading more results: $e');
    }
  }
  
  List<ProductModel> _getMockMoreResults() {
    final now = DateTime.now();
    return [
      ProductModel(
        id: '6',
        name: 'Bluetooth Speaker',
        description: 'Portable speaker with deep bass',
        price: 59.99,
        compareAtPrice: 79.99,
        images: [
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1636&q=80',
        ],
        quantity: 28,
        categoryId: '1',
        sellerId: 'seller1',
        sellerName: 'Tech World',
        rating: 4.4,
        reviewCount: 65,
        isFeatured: false,
        isNewArrival: true,
        createdAt: now,
        updatedAt: now,
        brand: 'AudioPro',
      ),
      ProductModel(
        id: '7',
        name: 'Smart Home Hub',
        description: 'Control your home with voice commands',
        price: 129.99,
        compareAtPrice: null,
        images: [
          'https://images.unsplash.com/photo-1558002038-1055e2e92f8a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        quantity: 18,
        categoryId: '1',
        sellerId: 'seller2',
        sellerName: 'Smart Solutions',
        rating: 4.7,
        reviewCount: 42,
        isFeatured: true,
        isNewArrival: false,
        createdAt: now,
        updatedAt: now,
        brand: 'HomeConnect',
      ),
    ];
  }
  
  void clearSearch() {
    textController.clear();
    searchResults.clear();
  }
  
  void removeFromSearchHistory(String query) {
    searchHistory.remove(query);
    // In a real app, this would be saved to storage
    // _storageService.saveSearchHistory(searchHistory);
  }
  
  void clearSearchHistory() {
    searchHistory.clear();
    // In a real app, this would be saved to storage
    // _storageService.clearSearchHistory();
  }
  
  void setFilter(String key, dynamic value) {
    activeFilters[key] = value;
    search(textController.text);
  }
  
  void removeFilter(String key) {
    activeFilters.remove(key);
    search(textController.text);
  }
  
  void clearFilters() {
    activeFilters.clear();
    search(textController.text);
  }
  
  void setSortOption(String option) {
    sortOption.value = option;
    search(textController.text);
  }
}