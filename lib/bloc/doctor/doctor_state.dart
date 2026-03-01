import 'package:medicalcare_connect/models/doctor_model.dart';

abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<Doctor> doctors;

  DoctorLoaded(this.doctors);
}

class DoctorError extends DoctorState {
  final String message;

  DoctorError(this.message);
}
