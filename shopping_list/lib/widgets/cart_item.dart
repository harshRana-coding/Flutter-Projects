import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.removeItem,
  });
  final GroceryItem item;
  final void Function(GroceryItem item) removeItem;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction){
        removeItem(item);
      },
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        leading: Container(
          height: 24,
          width: 24,
          color: item.category.color,
        ),
        title: Text(item.name),
        trailing: Text(
          item.quantity.toString(),
        ),
      ),
    );
  }
}
