import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/login/models/form_submission_status.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordObscuredChanged>(_onLoginPasswordObscuredChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;


  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      passwordObscured: true,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      passwordObscured: true,
    ));
  }

  void _onLoginPasswordObscuredChanged(
    LoginPasswordObscuredChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      passwordObscured: event.passwordObscured,
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValidEmail && !state.isPasswordEmpty) {
      emit(state.copyWith(status: const FormSubmissionStatusSubmitting()));
      try {
        await _authenticationRepository.logIn(
          email: state.email,
          password: state.password,
        );

        await _userRepository.setUser(User(const Uuid().v4(), email: state.email));
        
        emit(state.copyWith(status: const FormSubmissionStatusSuccess()));
      } catch (e) {
        emit(state.copyWith(status: FormSubmissionStatusFailed(e.toString())));
      }
    }
  }
}
