import 'package:flutter/material.dart';
import 'package:meals/provider/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/filters_screen.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/provider/favourite_meals_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  var activeScreenTitle = 'Categories';
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      activeScreenTitle = index == 0 ? 'Categories' : 'Your Favourite';
    });
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterMealProvider);

    Widget activeScreen = CategoriesScreen(
      availableMeals: availableMeals,
    );
    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      activeScreen = MealsScreen(
        meals: favouriteMeals,
      );
    }
    return Scaffold(
      drawer: MainDrawer(
        onSelect: _setScreen,
      ),
      appBar: AppBar(
        title: Text(
          activeScreenTitle,
        ),
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectPage(index);
          },
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border), label: 'Favourites'),
          ]),
    );
  }
}
