import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/location/location.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:store_service/store_service.dart';

import '../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}
class MockStoreService extends Mock implements StoreService {}

class MockStoreBloc extends MockBloc<StoreEvent, StoreState> implements StoreBloc {}

void main() {

  late LocationRepository locationRepository;
  late StoreService storeService;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeService = MockStoreService();
  });

  group('StoreList', () {
    late StoreBloc storeBloc;

    setUp(() {
      storeBloc = MockStoreBloc();
    });

    // testWidgets('adds Store Fetch to Store Page appears',
    // (tester) async {  
    //   when(() => storeBloc.state).thenReturn(const StoreState());

    //   await tester.pumpApp(
    //     BlocProvider.value(
    //       value: storeBloc,
    //       child: const Scaffold(body: StoresList(null, 'STORES NEARBY')),
    //     ),
    //   );

      
    //   verify(() => 
    //     storeBloc.add(storeFetched()),
    //   ).called(1);
    // });
});
}