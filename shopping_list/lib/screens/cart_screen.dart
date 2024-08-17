import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_screen.dart';
import 'package:shopping_list/widgets/cart_item.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  List<GroceryItem> _groceryList = [];
  String? _error;
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _removeItem(GroceryItem item){
    final url = Uri.https('shopping-list-61546-default-rtdb.asia-southeast1.firebasedatabase.app', 'shopping-list/${item.id}.json');
    http.delete(url);
    setState(() {
      _groceryList.remove(item);
    });
  }

  void _loadState() async {
    final url = Uri.https(
        'shopping-list-61546-default-rtdb.asia-southeast1.firebasedatabase.app', 'shopping-list.json');
    try{
      final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        isLoading = false;
        _error = "Failed to fetch items.Please try again later.";
      });
    }
    if(response.body == 'null'){
      setState((){
        isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    if(listData.isEmpty){
      setState(() {
      isLoading = false;
      });
      return;
    }
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (cartitem) => cartitem.value.name == item.value['category'])
          .value;
      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryList = loadedItems;
      isLoading = false;
    });
    }catch(err){
      setState(() {
        isLoading = false;
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

  void openAddScreen() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewScreen()),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryList.add(newItem);
    });
  }

  Widget content = const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Uh No the list is empty.'),
        SizedBox(
          height: 10,
        ),
        Text('Try adding items'),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: openAddScreen,
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: _groceryList.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                return CartItem(
                  item: _groceryList[index],
                  removeItem : _removeItem,
                );
              })
          : isLoading? const Center(
        child: CircularProgressIndicator() ) : content,
    );
  }
}
