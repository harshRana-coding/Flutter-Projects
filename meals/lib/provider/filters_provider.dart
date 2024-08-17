import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

enum Filter{
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersProviderNotifier extends StateNotifier<Map<Filter,bool>>{
  FiltersProviderNotifier() : super({
     Filter.glutenFree : false,
  Filter.lactoseFree : false,
  Filter.vegetarian : false,
  Filter.vegan : false,
  });

  void setFilter(Filter filter,bool isActive){
    state = {
      ...state,
      filter : isActive
    };
  }

  void setFilters(Map<Filter,bool> chosenFilters){
    state = chosenFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersProviderNotifier,Map<Filter,bool>>((ref) {
  return FiltersProviderNotifier();
});

final filterMealProvider = Provider((ref){
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal){
      if(activeFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(activeFilters[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      if(activeFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();
});