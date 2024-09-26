import 'package:flite/flite.dart';
part 'vehicle_model.g.dart';

@Schema()
class VehicleModel {
  @primary
  final int id;
  final String name;
  final String? description;

  @Foreign(
    "Manufacturer",
    "id",
    Operation.cascade,
    Operation.restrict,
  )
  final int? manufacturerId;

  @Foreign("Country", "id")
  final int? countryId;

  const VehicleModel({
    required this.id,
    required this.name,
    this.description,
    this.manufacturerId,
    this.countryId,
  });

  // @FromJson()
  VehicleModel.fromJson(final Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        manufacturerId = json["manufacturerId"],
        countryId = json["countryId"];

  // @ToJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'manufacturerId': manufacturerId,
      'countryId': countryId,
    };
  }
}
