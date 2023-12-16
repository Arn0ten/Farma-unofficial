import '../../models/product.dart';


class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() => _instance;

  CartService._internal();

  List<Product> cartItems = [];

  void addToCart(Product product) {
    print("Adding to cart in CartService: ${product.name}");
    cartItems.add(product);
    print("Added to cart in CartService successfully");
  }

  List<Product> getCartItems() {
    return List.from(cartItems);
  }
}
