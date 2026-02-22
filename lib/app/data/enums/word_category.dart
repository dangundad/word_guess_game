enum WordCategory {
  general,
  animals,
  food,
  countries;

  String get assetPath {
    switch (this) {
      case WordCategory.general:
        return 'assets/data/words_general.json';
      case WordCategory.animals:
        return 'assets/data/words_animals.json';
      case WordCategory.food:
        return 'assets/data/words_food.json';
      case WordCategory.countries:
        return 'assets/data/words_countries.json';
    }
  }

  String get displayKey {
    switch (this) {
      case WordCategory.general:
        return 'cat_general';
      case WordCategory.animals:
        return 'cat_animals';
      case WordCategory.food:
        return 'cat_food';
      case WordCategory.countries:
        return 'cat_countries';
    }
  }
}
