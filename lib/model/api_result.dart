class ApiResult {
  ApiResult({
    required this.isFood,
    required this.results,
  });

  late final bool isFood;
  late final List<Results> results;

  ApiResult.fromJson(Map<String, dynamic> json) {
    isFood = json['is_food'];
    results = List.from(json['results']).map((e) => Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_food'] = isFood;
    data['results'] = results.map((e) => e.toJson()).toList();
    return data;
  }
}

class Results {
  Results({
    required this.items,
    required this.group,
  });

  late final List<Items> items;
  late final String group;

  Results.fromJson(Map<String, dynamic> json) {
    items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['items'] = items.map((e) => e.toJson()).toList();
    data['group'] = group;
    return data;
  }
}

class Items {
  Items({
    // required this.servingSizes,
    required this.score,
    // required this.nutrition,
    required this.name,
    required this.foodId,
    required this.group,
  });

  // late final List<ServingSizes> servingSizes;
  late final int score;

  // late final Nutrition nutrition;
  late final String name;
  late final String foodId;
  late final String? group;

  Items.fromJson(Map<String, dynamic> json) {
    // servingSizes = List.from(json['servingSizes']).map((e) => ServingSizes.fromJson(e)).toList();
    score = json['score'];
    // nutrition = Nutrition.fromJson(json['nutrition']);
    name = json['name'];
    foodId = json['food_id'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['servingSizes'] = servingSizes.map((e) => e.toJson()).toList();
    data['score'] = score;
    // data['nutrition'] = nutrition.toJson();
    data['name'] = name;
    data['food_id'] = foodId;
    data['group'] = group;
    return data;
  }
}

// class ServingSizes {
//   ServingSizes({
//     required this.unit,
//   });
//   late final String? unit;
//
//   ServingSizes.fromJson(Map<String, dynamic> json) {
//     unit = json['unit'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['unit'] = unit;
//     return data;
//   }
// }

// class Nutrition {
//   Nutrition({
//     required this.totalCarbs,
//     required this.totalFat,
//     required this.protein,
//     required this.calories,
//   });
//   late final double totalCarbs;
//   late final double totalFat;
//   late final double protein;
//   late final double calories;
//
//   Nutrition.fromJson(Map<String, dynamic> json) {
//     totalCarbs = 1.0 * (json['totalCarbs'] ?? 0.0);
//     totalFat = 1.0 * (json['totalFat'] ?? 0.0);
//     protein = 1.0 * (json['protein'] ?? 0.0);
//     calories = 1.0 * (json['calories'] ?? 0.0);
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['totalCarbs'] = totalCarbs;
//     data['totalFat'] = totalFat;
//     data['protein'] = protein;
//     data['calories'] = calories;
//     return data;
//   }
// }
