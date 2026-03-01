# MedicalCare Connect

MedicalCare Connect is a Flutter application that allows users to register, login, view doctors, 
filter by specialization, and book consultation appointments. 
The application uses Firebase Authentication for secure login and Cloud Firestore for storing 
doctors and appointment data. BLoC is used for state management.

---

## Author

Pushpa Madasamy  
Flutter Developer

---

## Features Implemented

### Authentication
- User registration using Firebase Authentication
- User login
- Logout functionality

### Doctor Module
- Fetch doctors from Firebase Cloud Firestore
- Display doctor name, specialization, availability, and consultation fee
- Filter doctors by specialization

### Appointment Booking
- Select appointment date and time
- Automatic calculation of:
    - Start time
    - End time
    - Duration
    - Total consultation amount
    - Commission
    - Doctor earnings
- Store appointment details in Firebase Firestore

### Appointment History
- View booked appointments
- Fetch appointment data from Firestore

### Architecture
- BLoC State Management
- Clean architecture using:
    - Models
    - Services
    - Screens
    - BLoC

---

## Technologies Used

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- BLoC State Management
- Material UI

---

## Firebase Firestore Structure

### doctors collection

doctors  
doctorId  
name  
specialization  
available  
fee

### appointments collection

appointments  
appointmentId  
doctorId  
doctorName  
userId  
startTime  
endTime  
duration  
totalAmount  
commission  
doctorEarning  
createdAt

---

## How to Run the Project

Clone repository:

git clone https://github.com/pushpa-workhub/medicalcare_connect

Open project:

cd medicalcare_connect

Install dependencies:

flutter pub get

Run project:

flutter run

---

## Build APK

flutter build apk

APK location:

build/app/outputs/flutter-apk/app-release.apk

---

## Project Structure

lib/
bloc/
models/
services/
screens/
main.dart
