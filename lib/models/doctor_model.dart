class Doctor {
  final String id;
  final String name;
  final String specialization;
  final bool available;
  final double fee;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.available,
    required this.fee,
  });

  factory Doctor.fromFirestore(String id, Map<String, dynamic> data) {
    return Doctor(
      id: id,
      name: data["name"],
      specialization: data["specialization"],
      available: data["available"],
      fee: (data["fee"] as num).toDouble(),
    );
  }
}
