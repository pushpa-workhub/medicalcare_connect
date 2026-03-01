import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalcare_connect/models/doctor_model.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    final snapshot = await _firestore.collection("doctors").get();

    return snapshot.docs.map((doc) {
      return Doctor.fromFirestore(doc.id, doc.data());
    }).toList();
  }
}
