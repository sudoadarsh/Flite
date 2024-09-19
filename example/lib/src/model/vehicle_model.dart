import 'package:flite/flite.dart';

@Schema()
class VehicleModel {
  final int id;
  final String name;
  final String? description;

  const VehicleModel(
      {required this.id, required this.name, required this.description});

  @fromJson
  VehicleModel.fromJson(final Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"];
}
