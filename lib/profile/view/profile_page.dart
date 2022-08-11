import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pondrop/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/location/bloc/location_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _positionLabel(),
                _positionButton(),
                const SizedBox(height: 30),
                _takePhotoButton(),
                const SizedBox(height: 30),
                const Text(
                  'User ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (context) {
                    final userId = context.select(
                      (AuthenticationBloc bloc) => bloc.state.user.id,
                    );
                    return Text(userId);
                  },
                ),
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (context) {
                    final email = context.select(
                      (AuthenticationBloc bloc) => bloc.state.user.email,
                    );
                    return Text(email);
                  },
                ),
                ElevatedButton(
                  child: const Text('Sign out'),
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _positionLabel() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Lat:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' ${state.position?.latitude ?? 0}',
                  ),
                  const TextSpan(
                    text: '\n',
                  ),
                  const TextSpan(
                    text: 'Lng:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' ${state.position?.longitude ?? 0}',
                  ),
                  const TextSpan(
                    text: '\n',
                  ),
                  TextSpan(
                    text: state.position?.timestamp != null
                          ? DateFormat.yMd()
                              .add_jm()
                              .format(state.position!.timestamp!.toLocal())
                          : '00/00/00 00:00',
                  ),
                  const TextSpan(
                    text: '\n',
                  ),
                  TextSpan(
                    text: state.address?.city ?? 'null island',
                  ),
                ],
              ),
            ),
            Text('Lat: ${state.position?.latitude ?? 0}'),
            Text('Lng: ${state.position?.longitude ?? 0}'),
            Text(state.position?.timestamp != null
                ? DateFormat.yMd()
                    .add_jm()
                    .format(state.position!.timestamp!.toLocal())
                : '00/00/00 00:00'),
            Text(state.address?.city ?? 'null island'),
          ],
        );
      },
      buildWhen: (o, n) => o.position != n.position,
    );
  }

  Widget _positionButton() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state.isLocating) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          child: const Text('Update location'),
          onPressed: () {
            context.read<LocationBloc>().add(LocationPositionUpdateRequested());
          },
        );
      },
      buildWhen: (o, n) => o.isLocating != n.isLocating,
    );
  }

  Widget _takePhotoButton() {
    return ElevatedButton(
      child: const Text('Take photo'),
      onPressed: () async {
        final imagePicker = ImagePicker();
        final image = await imagePicker.pickImage(source: ImageSource.camera);
      },
    );
  }
}
