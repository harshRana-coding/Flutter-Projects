import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_item.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  
  var isSending = false;
  var _enteredTitle = '';
  var _enteredQuanity = 1;
  var _enteredCategory = categories[Categories.vegetables];
  final _formkey = GlobalKey<FormState>();
  void _saveState() async {
    _formkey.currentState!.validate();
    _formkey.currentState!.save();
    setState(() {
      isSending = true;
    });
    final url = Uri.https(
        'shopping-list-61546-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredTitle,
          'quantity': _enteredQuanity,
          'category': _enteredCategory!.name,
        }));
    final Map<String, dynamic> resData = json.decode(response.body);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop(GroceryItem(
      id: resData["name"],
      name: _enteredTitle,
      quantity: _enteredQuanity,
      category: _enteredCategory!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add an item",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
                keyboardType: TextInputType.text,
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuanity.toString(),
                      decoration: const InputDecoration(
                        label: Text(
                          "Quantity",
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuanity = int.tryParse(value!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _enteredCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(children: [
                              Container(
                                height: 10,
                                width: 10,
                                color: category.value.color,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(category.value.name),
                            ]),
                          ),
                      ],
                      onChanged: (obj) {
                        _enteredCategory = obj;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending ? null : () {
                      _formkey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : _saveState,
                    child: isSending ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(),)  : const Text("Add an Item"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
