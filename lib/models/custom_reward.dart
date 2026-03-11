class CustomReward {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String icon;

  const CustomReward({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'cost': cost,
        'icon': icon,
      };

  factory CustomReward.fromJson(Map<String, dynamic> json) => CustomReward(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        cost: json['cost'] as int,
        icon: json['icon'] as String,
      );
}
