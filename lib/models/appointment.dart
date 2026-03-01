import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String userId;
  final String doctorId;
  final String doctorName;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final double totalAmount;
  final double commission;
  final double doctorEarning;
  final DateTime createdAt;

  Appointment({
    required this.userId,
    required this.doctorId,
    required this.doctorName,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalAmount,
    required this.commission,
    required this.doctorEarning,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "doctorId": doctorId,
      "doctorName": doctorName,
      "startTime": startTime,
      "endTime": endTime,
      "duration": duration,
      "totalAmount": totalAmount,
      "commission": commission,
      "doctorEarning": doctorEarning,
      "createdAt": createdAt,
    };
  }

  factory Appointment.fromFirestore(Map<String, dynamic> data) {
    return Appointment(
      userId: data["userId"],
      doctorId: data["doctorId"],
      doctorName: data["doctorName"],
      startTime: (data["startTime"] as Timestamp).toDate(),
      endTime: (data["endTime"] as Timestamp).toDate(),
      duration: data["duration"],
      totalAmount: (data["totalAmount"] as num).toDouble(),
      commission: (data["commission"] as num).toDouble(),
      doctorEarning: (data["doctorEarning"] as num).toDouble(),
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }
}
