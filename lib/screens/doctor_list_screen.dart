import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicalcare_connect/bloc/doctor/doctor_bloc.dart';
import 'package:medicalcare_connect/bloc/doctor/doctor_event.dart';
import 'package:medicalcare_connect/bloc/doctor/doctor_state.dart';
import 'package:medicalcare_connect/models/doctor_model.dart';
import 'package:medicalcare_connect/screens/appointment_list_screen.dart';
import 'package:medicalcare_connect/screens/login_screen.dart';
import 'package:medicalcare_connect/services/appointment_service.dart';
import 'package:medicalcare_connect/services/doctor_service.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String selectedSpecialization = "All";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorBloc(DoctorService())..add(FetchDoctorsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctors"),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentListScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DoctorBloc, DoctorState>(
          builder: (context, state) {
            if (state is DoctorLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DoctorLoaded) {
              final doctors = state.doctors;
              if (doctors.isEmpty) {
                return const Center(child: Text("No doctors found"));
              }
              final specializations = [
                "All",
                ...doctors.map((d) => d.specialization).toSet(),
              ];
              final filteredDoctors = selectedSpecialization == "All"
                  ? doctors
                  : doctors
                        .where(
                          (d) => d.specialization == selectedSpecialization,
                        )
                        .toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      value: selectedSpecialization,
                      isExpanded: true,
                      items: specializations.map((spec) {
                        return DropdownMenuItem(value: spec, child: Text(spec));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSpecialization = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        Doctor doctor = filteredDoctors[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(doctor.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.specialization),
                                Text("Fee: ₹${doctor.fee}"),
                              ],
                            ),
                            trailing: doctor.available
                                ? ElevatedButton(
                                    onPressed: () async {
                                      _bookDoctor(doctor);
                                    },
                                    child: const Text("Book"),
                                  )
                                : const Text(
                                    "Unavailable",
                                    style: TextStyle(color: Colors.red),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            if (state is DoctorError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> _bookDoctor(Doctor doctor) async {
    final appointmentService = AppointmentService();
    final messenger = ScaffoldMessenger.of(context);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (!mounted || pickedDate == null) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!mounted || pickedTime == null) return;
    DateTime startTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    await appointmentService.bookAppointment(
      doctorId: doctor.id,
      doctorName: doctor.name,
      fee: doctor.fee,
      startTime: startTime,
    );
    if (!mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text("Appointment booked successfully")),
    );
  }
}
