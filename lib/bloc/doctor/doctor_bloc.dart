import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicalcare_connect/bloc/doctor/doctor_event.dart';
import 'package:medicalcare_connect/bloc/doctor/doctor_state.dart';
import 'package:medicalcare_connect/services/doctor_service.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorService doctorService;

  DoctorBloc(this.doctorService) : super(DoctorInitial()) {
    on<FetchDoctorsEvent>((event, emit) async {
      emit(DoctorLoading());

      try {
        final doctors = await doctorService.fetchDoctors();
        emit(DoctorLoaded(doctors));
      } catch (e) {
        emit(DoctorError(e.toString()));
      }
    });
  }
}
