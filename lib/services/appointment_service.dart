import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicalcare_connect/models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> bookAppointment({
    required String doctorId,
    required String doctorName,
    required double fee,
    required DateTime startTime,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }
    int duration = 30;
    DateTime endTime = startTime.add(Duration(minutes: duration));
    double totalAmount = fee;
    double commission = totalAmount * 0.20;
    double doctorEarning = totalAmount - commission;

    Appointment appointment = Appointment(
      userId: user.uid,
      doctorId: doctorId,
      doctorName: doctorName,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      totalAmount: totalAmount,
      commission: commission,
      doctorEarning: doctorEarning,
      createdAt: DateTime.now(),
    );

    await _firestore.collection("appointments").add(appointment.toMap());
  }

  Future<List<Appointment>> fetchAppointments() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }
    final snapshot = await _firestore
        .collection("appointments")
        .where("userId", isEqualTo: user.uid)
        .get();
    return snapshot.docs.map((doc) {
      return Appointment.fromFirestore(doc.data());
    }).toList();
  }
}
