class CartItem {
  final String id;
  final String image;
  final String name;
  final int quantity;
  final int price;
  final String size;
  final String discription;

  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price,
      required this.image,
      required this.size,
      required this.discription
      });
}