import 'package:flutter/material.dart';
import 'package:medicalcare_connect/models/appointment.dart';
import 'package:medicalcare_connect/services/appointment_service.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final AppointmentService service = AppointmentService();
  List<Appointment> appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      appointments = await service.fetchAppointments();
    } catch (e) {
      appointments = [];
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text("No appointments found"))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(appointment.doctorName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start: ${appointment.startTime}"),
                        Text("Duration: ${appointment.duration} min"),
                        Text("Amount: ₹${appointment.totalAmount}"),
                        Text("Doctor earns: ₹${appointment.doctorEarning}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
