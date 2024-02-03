class AIResultModel {
  final String breed; // 닮은 견종
  final double probability; // 닮은 견종 확률

  AIResultModel({
    required this.breed,
    required this.probability,
  });

  AIResultModel.fromMap(Map<String, dynamic> res)
    : breed = res['breed'],
      probability = res['probability'];
}