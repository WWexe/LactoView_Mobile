class MilkCollection {
  final int id;
  final int producerId;
  final String producerFirstName;
  final String producerLastName;
  final int producerPropertyId;
  final String propertyName;
  final double volumeLt;
  final String temperature;
  final bool producerPresent;
  final double ph;
  final String hygiene;
  final bool sample;
  final String tubeNumber;
  final String observation;
  final String status;
  final int collectorId;
  final int analysisId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MilkCollection({
    required this.id,
    required this.producerId,
    required this.producerFirstName,
    required this.producerLastName,
    required this.producerPropertyId,
    required this.propertyName,
    required this.temperature,
    required this.volumeLt,
    required this.producerPresent,
    required this.ph,
    required this.hygiene,
    required this.sample,
    required this.tubeNumber,
    required this.observation,
    required this.status,
    required this.collectorId,
    required this.analysisId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MilkCollection.fromJson(Map<String, dynamic> json) {
    return MilkCollection(
      id: json['id'],
      producerId: json['producer_id'],
      producerFirstName: json['producerFirstName'],
      producerLastName: json['producerLastName'],
      producerPropertyId: json['producer_property'],
      propertyName: json['propertyName'],
      temperature: json['temperature'],
      volumeLt: (json['volume_lt'] as num).toDouble(),
      producerPresent: json['producer_present'],
      ph: json['ph'],
      hygiene: json['hygiene'],
      sample: json['sample'],
      tubeNumber: json['tube_number'],
      observation: json['observation'],
      status: json['status'],
      collectorId: json['collector_id'],
      analysisId: json['analysis_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producer_id': producerId,
      'producer_property_id': producerPropertyId,
      'producer_First_Name': producerFirstName,
      'producer_Last_Name': producerLastName,
      'property_Name': propertyName,
      'temperature': temperature,
      'volume_lt': volumeLt,
      'producer_present': producerPresent,
      'ph': ph,
      'observation': observation,
      'sample': sample,
      'tube_number': tubeNumber,
      'status': status,
      'collector_id': collectorId,
      'analysis_id': analysisId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
