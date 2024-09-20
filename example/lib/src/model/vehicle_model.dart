import 'package:flite/flite.dart';
part 'vehicle_model.g.dart';

@Schema()
class VehicleModel {
  final int id;
  final String name;
  final String? description;

  const VehicleModel(
      {required this.id, required this.name, required this.description});

  @FromJson()
  VehicleModel.fromJson(final Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"];

  @ToJson()
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
