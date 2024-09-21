import 'dart:convert';

List<MapSuggestion> mapSuggestionFromJson(String str) => List<MapSuggestion>.from(json.decode(str).map((x) => MapSuggestion.fromJson(x)));


class MapSuggestion {
  MapSuggestion({
    this.description,
    this.placeId,
  });

  String description;
  String placeId;

  factory MapSuggestion.fromJson(Map<String, dynamic> json) => MapSuggestion(
    description: json["description"] == null ? null : json["description"],
    placeId: json["place_id"] == null ? null : json["place_id"],
  );
}
