
class Prediction {
  late final placeId;
  late final mainText;
  late  final secondaryText;

  Prediction({
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  Prediction.fromJson(Map<String, dynamic> json,){
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}