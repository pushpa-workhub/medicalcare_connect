import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicalcare_connect/bloc/auth/auth_event.dart';
import 'package:medicalcare_connect/bloc/auth/auth_state.dart';
import 'package:medicalcare_connect/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await authService.login(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Login failed"));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await authService.register(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Register failed"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await authService.logout();
      emit(AuthInitial());
    });
  }
}
